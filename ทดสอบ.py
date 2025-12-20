from flask import Flask, render_template_string, Response, request
from TikTokLive import TikTokLiveClient
from TikTokLive.events import CommentEvent, ConnectEvent, DisconnectEvent, GiftEvent
import asyncio
import threading
import queue
import json

app = Flask(__name__)

chat_queue = queue.Queue()
current_status = "รอการเชื่อมต่อ..."
tiktok_client = None
client_thread = None

HTML = """
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TikTok Live - รีเซ็ตล้างข้อความสนิท</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f0f2f5; }
        h1 { color: #fe2c55; text-align: center; }
        .controls { text-align: center; margin: 30px 0; }
        input { padding: 12px; width: 260px; border-radius: 10px; border: 1px solid #ccc; font-size: 16px; }
        button { padding: 12px 20px; margin: 0 10px; background: #fe2c55; color: white; border: none; border-radius: 10px; font-size: 16px; cursor: pointer; }
        button:disabled { background: #ccc; cursor: not-allowed; }
        .voice-btn { background: #6c757d; margin: 8px 5px; padding: 10px 15px; font-size: 14px; }
        .voice-btn.active { background: #28a745; }
        #resetBtn { background: #dc3545; font-weight: bold; }
        #status { margin: 20px 0; font-weight: bold; color: #d63031; text-align: center; font-size: 18px; }
        #chat { height: 500px; overflow-y: auto; border: 1px solid #ddd; border-radius: 15px; padding: 20px; background: white; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .comment { margin: 12px 0; padding: 12px 18px; background: #e8f5e8; border-radius: 20px; max-width: 85%; }
        .gift { margin: 12px 0; padding: 14px 18px; background: #fffbe6; border-radius: 20px; border-left: 6px solid #ffc107; font-weight: bold; color: #d69e2e; max-width: 85%; }
        .user { font-weight: bold; color: #fe2c55; }
    </style>
</head>
<body>
    <h1>🎤 TikTok Live - รีเซ็ตล้างข้อความสนิท</h1>
    
    <div class="controls">
        <input type="text" id="username" placeholder="ใส่ username เช่น rip34593" required>
        <button id="connectBtn">เชื่อมต่อ</button>
        <button id="disconnectBtn" disabled>หยุด</button>
        <button id="resetBtn">รีเซ็ตทั้งหมด</button>
    </div>

    <div class="controls">
        <button id="voice1" class="voice-btn active">หญิงนุ่ม</button>
        <button id="voice2" class="voice-btn">หญิงเร็ว</button>
        <button id="voice3" class="voice-btn">ชายต่ำ</button>
        <button id="voice4" class="voice-btn">ชายกลาง</button>
    </div>
    
    <p id="status">สถานะ: {{ status }}</p>
    
    <div id="chat"></div>

    <script>
        let eventSource = null;
        const synth = window.speechSynthesis;
        let speechQueue = [];
        let isSpeaking = false;
        let currentRate = 0.9;
        let currentPitch = 1.3;

        function clearAll() {
            document.getElementById('chat').innerHTML = '';  // ล้างข้อความทั้งหมด
            synth.cancel();
            speechQueue = [];
            isSpeaking = false;
            if (eventSource) {
                eventSource.close();
                eventSource = null;
            }
        }

        function speakNext() {
            if (speechQueue.length === 0 || isSpeaking) return;
            isSpeaking = true;
            const text = speechQueue.shift();
            const utterance = new SpeechSynthesisUtterance(text);
            utterance.lang = 'th-TH';
            utterance.rate = currentRate;
            utterance.pitch = currentPitch;
            utterance.volume = 1.0;

            const voices = synth.getVoices();
            const thaiVoice = voices.find(v => v.lang.includes('th'));
            if (thaiVoice) utterance.voice = thaiVoice;

            utterance.onend = () => {
                isSpeaking = false;
                speakNext();
            };
            utterance.onerror = () => {
                isSpeaking = false;
                speakNext();
            };

            synth.speak(utterance);
        }

        function addToSpeechQueue(text) {
            if (!text) return;
            speechQueue.push(text);
            speakNext();
        }

        // เลือกเสียง (เหมือนเดิม)

        document.getElementById('voice1').onclick = function() {
            currentRate = 0.9; currentPitch = 1.3;
            this.classList.add('active');
            ['voice2','voice3','voice4'].forEach(id => document.getElementById(id).classList.remove('active'));
            addToSpeechQueue('เสียงหญิงนุ่มแล้วค่ะ');
        };
        document.getElementById('voice2').onclick = function() {
            currentRate = 1.2; currentPitch = 1.4;
            this.classList.add('active');
            ['voice1','voice3','voice4'].forEach(id => document.getElementById(id).classList.remove('active'));
            addToSpeechQueue('เสียงหญิงเร็วแล้วค่ะ');
        };
        document.getElementById('voice3').onclick = function() {
            currentRate = 0.8; currentPitch = 0.7;
            this.classList.add('active');
            ['voice1','voice2','voice4'].forEach(id => document.getElementById(id).classList.remove('active'));
            addToSpeechQueue('เสียงชายต่ำแล้วครับ');
        };
        document.getElementById('voice4').onclick = function() {
            currentRate = 0.9; currentPitch = 1.0;
            this.classList.add('active');
            ['voice1','voice2','voice3'].forEach(id => document.getElementById(id).classList.remove('active'));
            addToSpeechQueue('เสียงชายกลางแล้วครับ');
        };

        function startSSE() {
            clearAll();
            eventSource = new EventSource('/stream');
            eventSource.onmessage = function(e) {
                const data = JSON.parse(e.data);
                const chat = document.getElementById('chat');
                
                if (data.type === 'comment') {
                    const div = document.createElement('div');
                    div.className = 'comment';
                    div.innerHTML = `<span class="user">${data.user}</span>: ${data.comment}`;
                    chat.appendChild(div);
                    chat.scrollTop = chat.scrollHeight;
                    addToSpeechQueue(data.comment);
                } else if (data.type === 'gift') {
                    const div = document.createElement('div');
                    div.className = 'gift';
                    div.innerHTML = `🎁 <span class="user">${data.user}</span> ส่ง ${data.gift_name} ${data.count || ''}`;
                    chat.appendChild(div);
                    chat.scrollTop = chat.scrollHeight;
                    const countText = data.count ? data.count.replace('x', '') + ' ชิ้น' : '';
                    addToSpeechQueue(`ได้รับ ${data.gift_name} ${countText}`);
                } else if (data.type === 'status') {
                    document.getElementById('status').innerText = 'สถานะ: ' + data.message;
                    if (data.message.includes('สำเร็จ')) addToSpeechQueue('เชื่อมต่อสำเร็จแล้วค่ะ');
                }
            };
        }

        document.getElementById('connectBtn').onclick = function() {
            const username = document.getElementById('username').value.trim();
            if (username) {
                fetch('/connect?username=' + encodeURIComponent(username));
                this.disabled = true;
                document.getElementById('disconnectBtn').disabled = false;
                clearAll();
                startSSE();
            }
        };

        document.getElementById('disconnectBtn').onclick = function() {
            fetch('/disconnect');
            document.getElementById('connectBtn').disabled = false;
            this.disabled = true;
            clearAll();
            addToSpeechQueue('หยุดฟังแล้วค่ะ');
        };

        // ปุ่มรีเซ็ตล้างหมดจริง ๆ
        document.getElementById('resetBtn').onclick = function() {
            fetch('/disconnect');  // หยุดการเชื่อมต่อ
            document.getElementById('connectBtn').disabled = false;
            document.getElementById('disconnectBtn').disabled = true;
            document.getElementById('username').value = '';  // ล้างช่อง username
            clearAll();  // ล้างแชท + เสียง + SSE
            addToSpeechQueue('รีเซ็ตทั้งหมดเรียบร้อยแล้วค่ะ');
            document.getElementById('status').innerText = 'สถานะ: รอการเชื่อมต่อ...';
        };

        startSSE();
    </script>
</body>
</html>
"""

# Backend (แก้ nick_name + gift_sub_type)

async def on_connect(event: ConnectEvent):
    global current_status
    current_status = f"เชื่อมต่อสำเร็จกับ @{event.unique_id} ✅"
    print(current_status)
    chat_queue.put({'type': 'status', 'message': current_status})

async def on_comment(event: CommentEvent):
    user_name = event.user.nick_name if hasattr(event.user, 'nick_name') else "ผู้ใช้"
    chat_queue.put({'type': 'comment', 'user': user_name, 'comment': event.comment})

async def on_gift(event: GiftEvent):
    if hasattr(event.gift, 'gift_sub_type') and event.gift.gift_sub_type == 1 and not event.repeat_end:
        return
    count = f"x{event.repeat_count}" if event.repeat_count > 1 else ""
    gift_name = event.gift.name or "ของขวัญพิเศษ"
    user_name = event.user.nick_name if hasattr(event.user, 'nick_name') else "ผู้ใช้"
    chat_queue.put({'type': 'gift', 'user': user_name, 'gift_name': gift_name, 'count': count})

async def on_disconnect(event: DisconnectEvent):
    global current_status
    current_status = "ตัดการเชื่อมต่อ ⚠️"
    print(current_status)
    chat_queue.put({'type': 'status', 'message': current_status})

def run_tiktok_client(unique_id):
    global tiktok_client, current_status
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)

    if not unique_id.startswith('@'):
        unique_id = '@' + unique_id

    print(f"กำลังเชื่อมต่อกับ {unique_id}...")

    tiktok_client = TikTokLiveClient(unique_id=unique_id)

    tiktok_client.add_listener(ConnectEvent, on_connect)
    tiktok_client.add_listener(CommentEvent, on_comment)
    tiktok_client.add_listener(GiftEvent, on_gift)
    tiktok_client.add_listener(DisconnectEvent, on_disconnect)

    current_status = f"กำลังเชื่อมต่อกับ {unique_id}... ⏳"
    chat_queue.put({'type': 'status', 'message': current_status})

    try:
        loop.run_until_complete(tiktok_client.connect())
    except Exception as e:
        err = f"เชื่อมต่อล้มเหลว: {str(e)} ❌"
        print(err)
        current_status = err
        chat_queue.put({'type': 'status', 'message': err})

@app.route('/')
def index():
    return render_template_string(HTML, status=current_status)

@app.route('/connect')
def connect():
    global client_thread
    username = request.args.get('username', '').strip()
    if username and (not client_thread or not client_thread.is_alive()):
        client_thread = threading.Thread(target=run_tiktok_client, args=(username,))
        client_thread.daemon = True
        client_thread.start()
    return ''

@app.route('/disconnect')
def disconnect():
    global tiktok_client, client_thread
    if tiktok_client:
        try:
            asyncio.run_coroutine_threadsafe(tiktok_client.disconnect(), asyncio.get_event_loop())
        except:
            pass
        tiktok_client = None
        client_thread = None
    return ''

@app.route('/stream')
def stream():
    def event_stream():
        while True:
            try:
                data = chat_queue.get(timeout=2)
                yield f"data: {json.dumps(data)}\n\n"
            except queue.Empty:
                yield "data: {\"type\": \"keepalive\"}\n\n"
    return Response(event_stream(), mimetype="text/event-stream")

if __name__ == '__main__':
    print("🚀 เริ่มเซิร์ฟเวอร์ TikTok Live - รีเซ็ตล้างข้อความสนิท")
    print("เปิดเบราว์เซอร์ไปที่: http://localhost:5000")
    app.run(host='0.0.0.0', port=5000, threaded=True)
