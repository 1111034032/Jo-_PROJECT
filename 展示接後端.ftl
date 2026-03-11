<!DOCTYPE html>
<html lang="zh-TW">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>智慧生命徵象量測機器人</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            /* 現代、豐富的動態背景 - 單一粉色調 */
            background-color: #fcc7d0;
            height: 100vh;
            margin: 0;
            overflow: hidden;
            font-family: "Microsoft JhengHei", sans-serif;
        }

        /* 對話框的對話尖角 (置中朝下) */
        .speech-bubble::after {
            content: '';
            position: absolute;
            bottom: -20px;
            left: 50%;
            /* Center horizontally */
            transform: translateX(-50%);
            /* Adjust to exact center based on its width */
            border-width: 20px 20px 0 20px;
            /* Symmetrical border for center tail */
            border-style: solid;
            border-color: white transparent transparent transparent;
        }

        .main-container {
            max-width: 1280px;
            /* 適合 Surface Pro / Tablet 的寬度 */
            margin: 0 auto;
            height: 100vh;
            display: flex;
            flex-direction: row;
            /* Side-by-side Layout */
            gap: 40px;
            /* Space between Chat and Content Area */
            padding: 70px 30px 10px 40px;
            /* Top padding reserved for very thin navbar, larger side paddings */
            /* Top padding to account for fixed navbar */
            box-sizing: border-box;
            position: relative;
        }

        /* 下方內容大區塊的背景色 (稍微帶點透明與柔和藍) */
        .display-area {
            background-color: rgba(255, 255, 255, 0.4);
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            min-height: 0;
            /* Important for flex children to shrink properly */
        }

        /* 護士 GIF 固定位置 */
        .nurse-container {
            position: absolute;
            bottom: -15px;
            /* Align perfectly to the bottom edge */
            left: 5%;
            width: clamp(280px, 35vw, 420px);
            /* 再次放大 */
            /* 1.2x larger than previous 200/25/300px */
            /* 根據平板比例調整 */
            z-index: 10;
        }

        .nurse-gif {
            width: 100%;
            height: auto;
            max-height: 70vh;
            /* 跟著放寬最大高度限制 */
            /* Allowed to grow slightly more vertically */
            /* Prevent overflowing on short screens */
            object-fit: contain;
            object-position: bottom;
        }

        /* 打字機閃爍游標 */
        .typing-cursor {
            font-weight: bold;
            color: #374151;
            animation: blink 1s step-end infinite;
        }

        @keyframes blink {
            50% {
                opacity: 0;
            }
        }

        /* 蜜桃色大球背景動畫 */
        .bubbles {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 0;
            /* Behind all content */
            overflow: hidden;
            pointer-events: none;
            /* Let clicks pass through */
        }

        .bubble {
            position: absolute;
            bottom: -150px;
            /* Start below the screen */
            background: radial-gradient(circle at 30% 30%, rgba(255, 182, 193, 0.8), rgba(255, 127, 140, 0.4));
            border-radius: 50%;
            box-shadow: 0 8px 32px rgba(255, 150, 160, 0.2);
            backdrop-filter: blur(2px);
            animation: rise infinite ease-in;
        }

        /* Define rising and swaying animation */
        @keyframes rise {
            0% {
                transform: translateY(0) scale(1) rotate(0deg);
                opacity: 0;
            }

            10% {
                opacity: 1;
            }

            80% {
                opacity: 0.8;
            }

            100% {
                transform: translateY(-120vh) scale(1.5) rotate(360deg);
                opacity: 0;
            }
        }

        /* Different bubble sizes and animation durations */
        .bubble:nth-child(1) {
            width: 80px;
            height: 80px;
            left: 10%;
            animation-duration: 15s;
            animation-delay: 0s;
        }

        .bubble:nth-child(2) {
            width: 120px;
            height: 120px;
            left: 25%;
            animation-duration: 22s;
            animation-delay: 2s;
        }

        .bubble:nth-child(3) {
            width: 60px;
            height: 60px;
            left: 45%;
            animation-duration: 18s;
            animation-delay: 7s;
        }

        .bubble:nth-child(4) {
            width: 150px;
            height: 150px;
            left: 65%;
            animation-duration: 25s;
            animation-delay: 4s;
        }

        .bubble:nth-child(5) {
            width: 90px;
            height: 90px;
            left: 85%;
            animation-duration: 20s;
            animation-delay: 1s;
        }

        .bubble:nth-child(6) {
            width: 110px;
            height: 110px;
            left: 50%;
            animation-duration: 28s;
            animation-delay: 10s;
        }

        .bubble:nth-child(7) {
            width: 70px;
            height: 70px;
            left: 80%;
            animation-duration: 16s;
            animation-delay: 8s;
        }

        .bubble:nth-child(8) {
            width: 130px;
            height: 130px;
            left: 15%;
            animation-duration: 24s;
            animation-delay: 12s;
        }
    </style>
</head>

<body>

    <!-- 背景泡泡容器 -->
    <div class="bubbles">
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
    </div>

    <!-- Navbar -->
    <div
        class="absolute top-0 left-0 w-full px-8 py-1.5 md:py-2 flex justify-between items-center z-50 bg-white/40 backdrop-blur-sm border-b border-white/40 shadow-sm">
        <div class="flex items-center">
            <img src="./img/嘉義基督教醫院logo.png" alt="嘉義基督教醫院logo" class="h-8 md:h-10 w-auto drop-shadow-md">
        </div>
        <div id="datetime-display"
            class="text-lg md:text-xl font-black text-indigo-950 tracking-wider drop-shadow-md bg-white/60 px-3 py-1 md:py-1.5 rounded-xl md:rounded-2xl backdrop-blur-md border border-white/50">
        </div>
    </div>

    <div class="main-container relative">

        <!-- Left Side: Chat Bubble -->
        <div class="w-1/3 flex-shrink-0 flex justify-start items-start relative z-20">
            <div id="chat-bubble" class="speech-bubble relative bg-white rounded-3xl p-6 shadow-lg w-full mt-4"
                style="width: calc(100% + 20px); min-width: calc(100% + 20px); margin-left: -10px;">
                <p id="instruction-text" class="text-2xl leading-relaxed font-bold text-gray-700 min-h-[5rem]">
                </p>
            </div>
        </div>

        <!-- Right Side: Content Area -->
        <div class="w-2/3 flex-grow flex justify-end items-stretch border-box min-h-0 z-10 relative">
            <div id="content-area"
                class="display-area rounded-3xl w-full p-8 shadow-inner flex flex-col justify-center items-center text-center relative"
                style="width: calc(100% + 10px); min-width: calc(100% + 10px);">

                <!-- 初始掃碼畫面內容 -->
                <div id="initial-scan-content" class="absolute inset-0 w-full h-full overflow-hidden rounded-3xl p-4">
                    <video src="./img/掃描手環示意影片.mp4" autoplay loop muted playsinline
                        class="w-full h-full object-contain bg-white/50 rounded-2xl">
                    </video>
                </div>


            </div>
        </div>

        <div class="nurse-container">
            <img src="./img/slowedNurse.gif" alt="Nurse" class="nurse-gif"
                onerror="this.src='https://via.placeholder.com/300x400?text=Nurse+GIF'">
        </div>

        <button id="mock-scan-btn" onclick="handleScanSuccess()"
            class="absolute bottom-4 right-4 bg-gray-400 hover:bg-gray-500 text-white px-3 py-2 rounded-lg text-sm shadow-md transition opacity-50 hover:opacity-100 z-50">
            點擊模擬掃碼成功
        </button>

        <button id="mock-temp-btn" onclick="showTempResult()"
            class="absolute bottom-4 right-4 bg-gray-400 hover:bg-gray-500 text-white px-3 py-2 rounded-lg text-sm shadow-md transition opacity-50 hover:opacity-100 z-50 hidden">
            點擊模擬量測額溫成功
        </button>

        <button id="mock-bp-btn" onclick="showBpResult()"
            class="absolute bottom-4 right-4 bg-gray-400 hover:bg-gray-500 text-white px-3 py-2 rounded-lg text-sm shadow-md transition opacity-50 hover:opacity-100 z-50 hidden">
            點擊模擬量測血壓成功
        </button>

    </div>

    <script>
        let typingTimeout;
        window.measurementResults = { temp: {}, bp: {}, warnings: [] };

        // 打字效果函式
        function typeText(elementId, text, speed = 60) {
            const element = document.getElementById(elementId);
            if (!element) return;

            // 確保清除上一段未完成的打字動畫
            if (typingTimeout) {
                clearTimeout(typingTimeout);
            }

            element.innerHTML = "";
            let i = 0;

            const cursorSpan = document.createElement('span');
            cursorSpan.className = 'typing-cursor';
            cursorSpan.innerText = '|';

            function typeWriter() {
                if (i < text.length) {
                    let char = text.charAt(i);
                    // 移除舊的游標
                    if (element.lastChild === cursorSpan) {
                        element.removeChild(cursorSpan);
                    }

                    if (char === '\n') {
                        element.appendChild(document.createElement('br'));
                    } else {
                        element.appendChild(document.createTextNode(char));
                    }
                    // 重新加入游標
                    element.appendChild(cursorSpan);

                    i++;
                    typingTimeout = setTimeout(typeWriter, speed);
                } else if (element.lastChild !== cursorSpan) {
                    element.appendChild(cursorSpan);
                }
            }
            typeWriter();
        }

        // 時間更新函式
        function updateDateTime() {
            const now = new Date();
            const rocYear = now.getFullYear() - 1911;
            const month = now.getMonth() + 1;
            const date = now.getDate();
            const days = ['禮拜日', '禮拜一', '禮拜二', '禮拜三', '禮拜四', '禮拜五', '禮拜六'];
            const dayOfWeek = days[now.getDay()];

            const hours = String(now.getHours()).padStart(2, '0');
            const minutes = String(now.getMinutes()).padStart(2, '0');
            const seconds = String(now.getSeconds()).padStart(2, '0');

            const datetimeStr = `民國${rocYear}年${month}月${date}日 ${dayOfWeek} ${hours}:${minutes}:${seconds}`;
            const display = document.getElementById('datetime-display');
            if (display) {
                display.innerText = datetimeStr;
            }
        }

        // 網頁載入後馬上執行初始設定打字效果與時間
        document.addEventListener("DOMContentLoaded", () => {
            updateDateTime();
            setInterval(updateDateTime, 1000);
            typeText('instruction-text', '您好！我是您的量測助手。\n請拿起掃碼機掃描您手上的手環', 60);
        });

        // 處理掃碼成功邏輯
        function handleScanSuccess() {
            // 1. 隱藏原本的預設掃描畫面與模擬按鈕
            const initialContent = document.getElementById('initial-scan-content');
            if (initialContent) initialContent.classList.add('hidden');
            const mockBtn = document.getElementById('mock-scan-btn');
            if (mockBtn) mockBtn.classList.add('hidden');

            // 2. 更新下方內容區塊為歡迎資訊
            const contentArea = document.getElementById('content-area');
            const welcomeHtml = `
                <div id="welcome-content" class="flex flex-col items-center animate-fade-in my-8">
                    <div class="bg-gradient-to-tr from-green-400 to-emerald-500 rounded-full p-6 mb-8 shadow-lg shadow-green-200">
                        <svg class="w-20 h-20 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"></path></svg>
                    </div>
                    <div class="text-6xl font-extrabold text-indigo-950 mb-8 tracking-wide drop-shadow-sm">掃碼成功</div>
                    <p class="text-3xl text-indigo-700/80 leading-relaxed font-medium bg-white/60 px-12 py-6 rounded-3xl border border-white max-w-2xl text-center shadow-md">
                        歡迎 <span class="text-indigo-600 font-black text-5xl mx-2 drop-shadow-sm">王大明</span> 先生<br>
                        ID: <span class="tracking-wider font-mono font-bold text-indigo-800 bg-indigo-50/80 px-4 py-2 rounded-xl mt-4 inline-block border border-indigo-100 shadow-inner">A123456789</span>
                    </p>
                </div>
            `;
            // 將原本的其他節點 (如 action-buttons) 保留，插入新的歡迎內容
            contentArea.insertAdjacentHTML('afterbegin', welcomeHtml);

            // 3. 設定倒數秒數與更新提示文字
            let countdown = 5;

            // 由於 typeText 會有動畫時間，第一次先印出完整文字
            typeText('instruction-text', `掃碼成功！\n${countdown}秒後將自動跳轉至量測額溫...`, 60);

            // 建立每秒執行的計時器
            const timer = setInterval(() => {
                countdown--;

                // 確保清掉殘留的打字機動畫，防止兩者交錯導致文字重疊
                if (typingTimeout) {
                    clearTimeout(typingTimeout);
                }

                if (countdown > 0) {
                    // 更新秒數 (只替換文字，不重新觸發打字動畫會比較順)
                    document.getElementById('instruction-text').innerHTML =
                        `掃碼成功！<br>${countdown}秒後將自動跳轉至量測額溫...<span class="typing-cursor">|</span>`;
                } else {
                    // 4. 倒數結束，執行跳轉至量測額溫的邏輯
                    clearInterval(timer);

                    // 更新提示文字並帶入打字效果
                    typeText('instruction-text', '請您將額溫槍對準額頭，\n準備量測額溫...', 60);

                    // 移除剛剛的歡迎畫面
                    const welcomeContent = document.getElementById('welcome-content');
                    if (welcomeContent) welcomeContent.remove();

                    // 顯示額溫槍使用教學影片
                    const tempVideoHtml = `
                        <div id="temp-video-content" class="absolute inset-0 w-full h-full overflow-hidden rounded-3xl p-4">
                            <video src="./img/額溫槍使用教學影片.mp4" autoplay loop muted playsinline
                                class="w-full h-full object-contain bg-white/50 rounded-2xl">
                            </video>
                        </div>
                    `;
                    contentArea.insertAdjacentHTML('afterbegin', tempVideoHtml);

                    // 顯示模擬量測額溫成功按鈕
                    const mockTempBtn = document.getElementById('mock-temp-btn');
                    if (mockTempBtn) mockTempBtn.classList.remove('hidden');
                }
            }, 1000);
        }

        // 處理模擬量測額溫成功邏輯
        function showTempResult() {
            // 隱藏影片與模擬按鈕
            const tempVideoContent = document.getElementById('temp-video-content');
            if (tempVideoContent) tempVideoContent.remove();

            const mockTempBtn = document.getElementById('mock-temp-btn');
            if (mockTempBtn) mockTempBtn.classList.add('hidden');

            const contentArea = document.getElementById('content-area');

            // 更新提示文字
            typeText('instruction-text', '額溫量測完成！', 60);

            // 建立新的額溫量測結果畫面內容
            const isNormal = Math.random() >= 0.5;
            let tempValueNum = 0;
            let tempStatusText = "溫度正常";

            if (isNormal) {
                tempValueNum = 36 + Math.random() * 1.4;
            } else {
                // 決定發燒(偏高)還是失溫(偏低)
                const isHigh = Math.random() >= 0.5;
                if (isHigh) {
                    tempValueNum = 37.5 + Math.random() * 2;
                    tempStatusText = "溫度偏高";
                } else {
                    tempValueNum = 35 + Math.random() * 0.9;
                    tempStatusText = "溫度偏低";
                }
            }

            const statusTextColor = isNormal ? "text-emerald-700" : "text-red-700";
            const statusBgColor = isNormal ? "bg-gradient-to-r from-emerald-50 to-teal-50" : "bg-gradient-to-r from-red-50 to-orange-50";
            const statusBorderColor = isNormal ? "border-emerald-200" : "border-red-200";
            const statusDotColor = isNormal ? "bg-emerald-400 shadow-[0_0_10px_rgba(52,211,153,0.8)]" : "bg-red-500 shadow-[0_0_12px_rgba(239,68,68,0.9)]";

            const tempValue = tempValueNum.toFixed(1);

            // 儲存額溫量測紀錄
            window.measurementResults.temp = {
                value: tempValue,
                statusText: tempStatusText,
                isNormal: isNormal
            };
            if (!isNormal) {
                window.measurementResults.warnings.push(`【額溫】 ${tempStatusText} (${tempValue}℃)`);
            }

            const circleColor = isNormal ? "bg-emerald-400" : "bg-red-400";
            const textColor = isNormal ? "text-emerald-500" : "text-red-500";
            const unitColor = isNormal ? "text-emerald-400" : "text-red-400";
            const borderColor = isNormal ? "border-emerald-100" : "border-red-100";
            const shadowColor = isNormal ? "shadow-emerald-100/50" : "shadow-red-100/50";
            const gradientFrom = isNormal ? "from-emerald-50" : "from-red-50";
            const gradientTo = isNormal ? "to-teal-50" : "to-orange-50";

            // 計算溫度計進度條比例 (假設最低 34度最高 42度)
            const minTemp = 34;
            const maxTemp = 42;
            let tempPercentage = ((tempValueNum - minTemp) / (maxTemp - minTemp)) * 100;
            if (tempPercentage < 0) tempPercentage = 0;
            if (tempPercentage > 100) tempPercentage = 100;

            // 溫度計填滿顏色 (高於 37.5 偏紅，低於 36 偏藍，中間綠)
            let barColor = "bg-gradient-to-r from-emerald-300 to-emerald-500";
            if (tempValueNum >= 37.5) {
                barColor = "bg-gradient-to-r from-orange-400 to-red-500";
            } else if (tempValueNum < 36.0) {
                barColor = "bg-gradient-to-r from-blue-300 to-blue-500";
            }

            const tempHtml = `
                <div id="temp-content" class="flex flex-col items-center animate-fade-in w-full px-12 max-w-2xl mx-auto">
                    <!-- 狀態膠囊 -->
                    <div class="${statusBgColor} border-2 ${statusBorderColor} px-8 py-3 rounded-full shadow-lg flex items-center space-x-4 mb-10 transform transition-all duration-500 hover:scale-105">
                        <div class="w-4 h-4 rounded-full animate-pulse ${statusDotColor}"></div>
                        <p class="text-3xl ${statusTextColor} font-extrabold tracking-widest">${tempStatusText}</p>
                    </div>

                    <!-- 主要數值區與溫度計結合 -->
                    <div class="w-full bg-white/70 backdrop-blur-md rounded-[2.5rem] p-10 border border-white/50 shadow-2xl flex flex-col items-center relative overflow-hidden">
                        <!-- 裝飾光暈 -->
                        <div class="absolute -top-10 -right-10 w-40 h-40 ${circleColor} rounded-full blur-3xl opacity-20"></div>
                        <div class="absolute -bottom-10 -left-10 w-40 h-40 ${circleColor} rounded-full blur-3xl opacity-20"></div>

                        <!-- 數字顯示 -->
                        <div class="relative bg-gradient-to-br ${gradientFrom} ${gradientTo} px-16 py-6 rounded-3xl border-2 ${borderColor} shadow-inner mb-10 z-10 w-full flex justify-center items-baseline">
                            <span class="text-8xl font-black ${textColor} tracking-tight drop-shadow-sm">${tempValue}</span>
                            <span class="text-5xl ${unitColor} font-bold ml-2">℃</span>
                        </div>

                        <!-- 溫度計 UI -->
                        <div class="w-full z-10">
                            <div class="flex justify-between text-sm font-bold text-gray-400 mb-2 px-1">
                                <span>34℃</span>
                                <span>36℃正常</span>
                                <span>37.5℃發燒</span>
                                <span>42℃</span>
                            </div>
                            <!-- 進度條外框與內框底色 -->
                            <div class="h-6 w-full bg-gray-200/80 rounded-full shadow-inner overflow-hidden border border-gray-300/50 p-1">
                                <!-- 進度條填滿 -->
                                <div class="h-full rounded-full transition-all duration-1000 ease-out relative ${barColor}"
                                     style="width: 0%;"
                                     id="temp-progress-bar">
                                     <!-- 閃爍的高光 -->
                                     <div class="absolute top-0 left-0 w-full h-1/2 bg-white/30 rounded-full"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `;

            contentArea.insertAdjacentHTML('afterbegin', tempHtml);

            // 觸發進度條動畫
            setTimeout(() => {
                const progressBar = document.getElementById('temp-progress-bar');
                if (progressBar) {
                    progressBar.style.width = `${tempPercentage}%`;
                }
            }, 100);

            // 自動倒數 5 秒跳轉至量測血壓
            let countdown = 5;

            // 更新提示文字
            typeText('instruction-text', `額溫量測完成！\n${countdown}秒後將自動跳轉至量測血壓...`, 60);

            // 建立每秒執行的計時器
            const timer = setInterval(() => {
                countdown--;

                if (typingTimeout) {
                    clearTimeout(typingTimeout);
                }

                const instructionP = document.getElementById('instruction-text');

                if (countdown > 0) {
                    if (instructionP) {
                        instructionP.innerHTML = `額溫量測完成！<br>${countdown}秒後將自動跳轉至量測血壓...<span class="typing-cursor">|</span>`;
                    }
                } else {
                    // 倒數結束，執行跳轉至量測血壓的邏輯
                    clearInterval(timer);

                    // 更新提示文字
                    typeText('instruction-text', '請將您的手臂伸入血壓計中，\n並按下機器上的開始按鈕...', 60);

                    // 移除原本的額溫結果畫面
                    const tempContent = document.getElementById('temp-content');
                    if (tempContent) tempContent.remove();

                    // 建立新的血壓模擬畫面 (暫時顯示血壓計圖示或指示)
                    const bpContentHtml = `
                        <div id="bp-content" class="absolute inset-0 w-full h-full overflow-hidden rounded-3xl p-4">
                            <video src="./img/隧道式血壓計使用教學影片.mp4" autoplay loop muted playsinline
                                class="w-full h-full object-contain bg-white/50 rounded-2xl">
                            </video>
                        </div>
                    `;
                    contentArea.insertAdjacentHTML('afterbegin', bpContentHtml);

                    // 顯示模擬量測血壓成功按鈕
                    const mockBpBtn = document.getElementById('mock-bp-btn');
                    if (mockBpBtn) mockBpBtn.classList.remove('hidden');
                }
            }, 1000);
        }

        // 處理模擬量測血壓成功邏輯
        function showBpResult() {
            // 隱藏模擬按鈕
            const mockBpBtn = document.getElementById('mock-bp-btn');
            if (mockBpBtn) mockBpBtn.classList.add('hidden');

            const contentArea = document.getElementById('content-area');

            // 移除等待畫面
            const bpWaitContent = document.getElementById('bp-content');
            if (bpWaitContent) bpWaitContent.remove();

            // 更新對話框文字為完成提示
            typeText('instruction-text', '血壓量測完成！\n請確認您的數據是否正確。', 60);

            // 建立血壓與脈搏結果畫面
            const isBpNormal = Math.random() >= 0.5;
            let sysValue = 120, diaValue = 80, pulseValue = 72;
            let statusText = "量測數值正常";
            let statusTextColor = "text-emerald-700";
            let statusBgColor = "bg-gradient-to-r from-emerald-50 to-teal-50";
            let statusBorderColor = "border-emerald-200";
            let statusDotColor = "bg-emerald-400 shadow-[0_0_10px_rgba(52,211,153,0.8)]";
            let sysColor = "text-gray-800", diaColor = "text-gray-800", pulseColor = "text-gray-800";

            if (!isBpNormal) {
                const abnormalType = Math.floor(Math.random() * 3); // 0: sys, 1: dia, 2: pulse
                if (abnormalType === 0) {
                    const isHigh = Math.random() >= 0.5;
                    if (isHigh) {
                        sysValue = 140 + Math.floor(Math.random() * 40);
                        statusText = "收縮壓偏高";
                    } else {
                        sysValue = 50 + Math.floor(Math.random() * 30);
                        statusText = "收縮壓偏低";
                    }
                    sysColor = "text-red-500";
                } else if (abnormalType === 1) {
                    const isHigh = Math.random() >= 0.5;
                    if (isHigh) {
                        diaValue = 90 + Math.floor(Math.random() * 20);
                        statusText = "舒張壓偏高";
                    } else {
                        diaValue = 30 + Math.floor(Math.random() * 20);
                        statusText = "舒張壓偏低";
                    }
                    diaColor = "text-red-500";
                } else {
                    const isHigh = Math.random() >= 0.5;
                    if (isHigh) {
                        pulseValue = 100 + Math.floor(Math.random() * 30);
                        statusText = "脈搏偏高";
                    } else {
                        pulseValue = 40 + Math.floor(Math.random() * 15);
                        statusText = "脈搏偏低";
                    }
                    pulseColor = "text-red-500";
                }
                statusTextColor = "text-red-700";
                statusBgColor = "bg-gradient-to-r from-red-50 to-orange-50";
                statusBorderColor = "border-red-200";
                statusDotColor = "bg-red-500 shadow-[0_0_12px_rgba(239,68,68,0.9)]";

                // 產生正常的另外兩個數值
                if (abnormalType !== 0) sysValue = 100 + Math.floor(Math.random() * 20);
                if (abnormalType !== 1) diaValue = 60 + Math.floor(Math.random() * 20);
                if (abnormalType !== 2) pulseValue = 60 + Math.floor(Math.random() * 40);
            } else {
                sysValue = 100 + Math.floor(Math.random() * 20);
                diaValue = 60 + Math.floor(Math.random() * 20);
                pulseValue = 60 + Math.floor(Math.random() * 40);
            }

            // 儲存血壓脈搏量測紀錄
            window.measurementResults.bp = {
                sys: sysValue,
                dia: diaValue,
                pulse: pulseValue,
                isNormal: isBpNormal,
                statusText: statusText
            };

            if (!isBpNormal) {
                let warningDetail = '';
                if (statusText.includes("收縮")) warningDetail = `(${sysValue} mmHg)`;
                else if (statusText.includes("舒張")) warningDetail = `(${diaValue} mmHg)`;
                else warningDetail = `(${pulseValue} BPM)`;
                window.measurementResults.warnings.push(`【血壓/脈搏】 ${statusText} ${warningDetail}`);
            }

            // 計算收縮壓與舒張壓百分比 (假設 sys: 80-180, dia: 50-120)
            const sysMin = 80, sysMax = 180;
            let sysPercentage = ((sysValue - sysMin) / (sysMax - sysMin)) * 100;
            if (sysPercentage < 0) sysPercentage = 0;
            if (sysPercentage > 100) sysPercentage = 100;

            const diaMin = 50, diaMax = 120;
            let diaPercentage = ((diaValue - diaMin) / (diaMax - diaMin)) * 100;
            if (diaPercentage < 0) diaPercentage = 0;
            if (diaPercentage > 100) diaPercentage = 100;

            let sysBarColor = "bg-gradient-to-r from-emerald-300 to-emerald-500";
            if (sysValue >= 140 || sysValue < 90) sysBarColor = "bg-gradient-to-r from-orange-400 to-red-500";

            let diaBarColor = "bg-gradient-to-r from-emerald-300 to-emerald-500";
            if (diaValue >= 90 || diaValue < 60) diaBarColor = "bg-gradient-to-r from-orange-400 to-red-500";

            const bpResultHtml = `
                <div id="bp-result-content" class="flex flex-col items-center animate-fade-in w-full px-8 max-w-full mx-auto">
                    <!-- 狀態膠囊 -->
                    <div class="${statusBgColor} border-2 ${statusBorderColor} px-8 py-3 rounded-full shadow-lg flex items-center space-x-4 mb-10 transform transition-all duration-500 hover:scale-105">
                        <div class="w-4 h-4 rounded-full animate-pulse ${statusDotColor}"></div>
                        <p class="text-3xl ${statusTextColor} font-extrabold tracking-widest">${statusText}</p>
                    </div>
                    
                    <div class="grid grid-cols-2 gap-8 w-full mb-8">
                        <!-- 血壓卡片 (懸浮泡泡風格) -->
                        <div class="bg-white/70 backdrop-blur-md rounded-[2.5rem] p-10 border border-white/50 shadow-2xl flex flex-col items-center justify-center relative overflow-hidden group transition-transform duration-300 min-h-[300px]">
                            <!-- 底部液體晃動波浪動畫 -->
                            <div class="absolute inset-0 z-0 overflow-hidden pointer-events-none rounded-[2.5rem]">
                                <!-- 液位容器，控制液體高度，w-200% 確保波浪平緩 -->
                                <div class="absolute top-[60%] left-1/2 w-[200%] aspect-square -translate-x-1/2 opacity-60 mix-blend-multiply">
                                    <!-- 波浪 1 -->
                                    <div class="absolute inset-0 rounded-[40%] bg-gradient-to-t from-red-400 to-red-300 animate-[spin_7s_linear_infinite]"></div>
                                    <!-- 波浪 2 -->
                                    <div class="absolute inset-0 rounded-[45%] bg-gradient-to-t from-orange-300 to-rose-300 animate-[spin_10s_linear_reverse_infinite] opacity-70"></div>
                                    <!-- 波浪 3 (深色底) -->
                                    <div class="absolute inset-0 rounded-[42%] bg-gradient-to-t from-red-500 to-orange-400 animate-[spin_12s_linear_infinite] opacity-50 mt-4"></div>
                                </div>
                            </div>

                            <div class="absolute top-0 right-0 w-32 h-32 bg-red-100 rounded-bl-full opacity-50 -mr-10 -mt-10 transition-transform group-hover:scale-110 z-0"></div>
                            
                            <div class="text-red-400/80 font-bold text-3xl mb-6 tracking-wider z-10">血壓 <span class="text-xl font-normal ml-2">SYS / DIA</span></div>
                            <div class="text-7xl font-black z-10 tracking-tighter mb-4"><span class="${sysColor} drop-shadow-sm">${sysValue}</span><span class="text-4xl text-gray-300 mx-3 font-light">/</span><span class="${diaColor} drop-shadow-sm">${diaValue}</span></div>
                            <div class="text-2xl font-bold tracking-widest text-red-500/80 z-10 bg-white/50 px-5 py-2 rounded-full backdrop-blur-sm border border-white/80 shadow-sm">mmHg</div>
                        </div>

                        <!-- 脈搏卡片 -->
                        <div class="bg-white/70 backdrop-blur-md rounded-[2.5rem] p-10 border border-white/50 shadow-2xl flex flex-col items-center justify-center relative overflow-hidden group transition-transform duration-300 min-h-[300px]">
                            <!-- 會跳動的心電圖背景 SVG -->
                            <div class="absolute inset-0 z-0 opacity-20 flex items-center justify-center overflow-hidden">
                                <svg class="w-full h-full text-blue-600 scale-150 animate-pulse" viewBox="0 0 500 150" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M0,75 L100,75 L125,25 L150,125 L175,25 L200,75 L500,75" stroke="currentColor" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>
                                    <path d="M-500,75 L-400,75 L-375,25 L-350,125 L-325,25 L-300,75 L0,75" stroke="currentColor" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>
                                </svg>
                            </div>

                            <div class="absolute top-0 right-0 w-32 h-32 bg-blue-100 rounded-bl-full opacity-50 -mr-10 -mt-10 transition-transform group-hover:scale-110 z-0"></div>
                            
                            <div class="text-blue-400/80 font-bold text-3xl mb-6 tracking-wider z-10 flex items-center">
                                脈搏 <span class="text-xl font-normal ml-2">PULSE</span>
                            </div>
                            
                            <div class="flex items-center space-x-4 z-10 mb-4">
                                <!-- 閃爍的心頭 Icon -->
                                <svg class="w-12 h-12 ${pulseColor === 'text-gray-800' ? 'text-blue-400' : pulseColor} animate-bounce" fill="currentColor" viewBox="0 0 24 24">
                                    <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                                </svg>
                                <div class="text-7xl font-black ${pulseColor} tracking-tighter drop-shadow-sm">${pulseValue}</div>
                            </div>
                            <div class="text-2xl font-bold tracking-widest text-blue-500/80 z-10 bg-white/50 px-5 py-2 rounded-full backdrop-blur-sm border border-white/80 shadow-sm">BPM</div>
                        </div>
                    </div>
                </div>
            `;

            contentArea.insertAdjacentHTML('afterbegin', bpResultHtml);

            // 自動倒數 5 秒跳轉至總覽畫面
            let countdown = 5;
            typeText('instruction-text', `血壓與脈搏量測完成！\n${countdown}秒後將為您整理量測總覽報告...`, 60);

            const timer = setInterval(() => {
                countdown--;
                if (typingTimeout) clearTimeout(typingTimeout);
                const instructionP = document.getElementById('instruction-text');

                if (countdown > 0) {
                    if (instructionP) {
                        instructionP.innerHTML = `血壓與脈搏量測完成！<br>${countdown}秒後將為您整理量測總覽報告...<span class="typing-cursor">|</span>`;
                    }
                } else {
                    clearInterval(timer);
                    showSummaryResult();
                }
            }, 1000);
        }

        // 處理總覽報告邏輯
        function showSummaryResult() {
            const contentArea = document.getElementById('content-area');
            const bpContent = document.getElementById('bp-result-content');
            if (bpContent) bpContent.remove();

            typeText('instruction-text', '全部量測完成！\n這是您的本次量測總覽報告。', 60);

            const temp = window.measurementResults.temp || {};
            const bp = window.measurementResults.bp || {};
            const warnings = window.measurementResults.warnings || [];

            let warningHtml = '';
            if (warnings.length > 0) {
                warningHtml = `
                    <div class="w-full bg-red-50/90 border-l-4 border-red-500 p-6 rounded-2xl shadow-sm mb-8 text-left animate-fade-in backdrop-blur-sm">
                        <div class="flex items-center mb-4">
                            <svg class="w-8 h-8 text-red-500 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path></svg>
                            <h3 class="text-2xl font-bold text-red-800 tracking-wider">異常警示提醒</h3>
                        </div>
                        <ul class="list-disc list-inside space-y-2 text-xl font-medium text-red-700 ml-2">
                            ${warnings.map(w => `<li>${w}</li>`).join('')}
                        </ul>
                    </div>
                `;
            } else {
                warningHtml = `
                    <div class="w-full bg-emerald-50/90 border-l-4 border-emerald-500 p-6 rounded-2xl shadow-sm mb-8 text-left animate-fade-in backdrop-blur-sm">
                        <div class="flex items-center">
                            <svg class="w-8 h-8 text-emerald-500 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                            <h3 class="text-2xl font-bold text-emerald-800 tracking-wider">各項量測結果全數正常，請繼續保持！</h3>
                        </div>
                    </div>
                `;
            }

            const getStatusColor = (isNormal) => isNormal ? "text-emerald-700 bg-emerald-100 border-emerald-300" : "text-red-700 bg-red-100 border-red-300";

            const summaryHtml = `
                <div id="summary-content" class="flex flex-col items-center animate-fade-in w-full px-0 mx-auto z-10 pt-4">

                    ${warningHtml}

                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 w-full animate-fade-in">
                        <!-- 額溫區塊 -->
                        <div class="col-span-1 bg-white/80 backdrop-blur-md rounded-3xl p-6 border border-white shadow-xl ${!temp.isNormal ? 'ring-2 ring-red-400' : ''} flex flex-col h-full">
                            <div class="text-gray-500 font-bold mb-10 tracking-wider flex items-center justify-between">
                                <span class="text-2xl">額溫</span>
                            </div>
                            <div class="flex items-baseline justify-center mb-2 flex-grow">
                                <span class="text-6xl font-black ${temp.isNormal ? 'text-gray-800' : 'text-red-600'} drop-shadow-sm">${temp.value}</span>
                                <span class="text-2xl text-gray-400 font-bold ml-2">℃</span>
                            </div>
                        </div>

                        <!-- 血壓脈搏區塊 -->
                        <div class="col-span-1 lg:col-span-2 bg-white/80 backdrop-blur-md rounded-3xl p-6 border border-white shadow-xl ${!bp.isNormal ? 'ring-2 ring-red-400' : ''} flex flex-col h-full">
                            <div class="text-gray-500 font-bold mb-6 tracking-wider flex items-center justify-between">
                                <span class="text-2xl">血壓與脈搏</span>
                            </div>
                            
                            <div class="flex flex-col md:flex-row justify-around items-center flex-grow">
                                <div class="flex flex-col items-center">
                                    <span class="text-sm font-bold text-gray-400 mb-2">收縮/舒張壓 (SYS/DIA)</span>
                                    <div class="flex flex-col xl:flex-row items-center whitespace-nowrap">
                                        <div class="flex items-baseline">
                                            <span class="text-6xl font-black ${(bp.sys >= 140 || bp.sys < 90) ? 'text-red-600' : 'text-gray-800'} drop-shadow-sm">${bp.sys}</span>
                                            <span class="text-3xl text-gray-300 mx-2 font-light">/</span>
                                            <span class="text-6xl font-black ${(bp.dia >= 90 || bp.dia < 60) ? 'text-red-600' : 'text-gray-700'} drop-shadow-sm">${bp.dia}</span>
                                        </div>
                                        <span class="text-base text-red-400/80 font-bold mt-1 xl:mt-0 xl:ml-2">mmHg</span>
                                    </div>
                                </div>
                                <div class="h-px w-full md:h-16 md:w-px bg-gray-300 my-4 md:my-0 md:mx-4"></div>
                                <div class="flex flex-col items-center">
                                    <span class="text-sm font-bold text-gray-400 mb-2">脈搏 (PULSE)</span>
                                    <div class="flex items-baseline whitespace-nowrap">
                                        <span class="text-6xl font-black ${(bp.pulse >= 100 || bp.pulse < 60) ? 'text-red-600' : 'text-gray-800'} drop-shadow-sm">${bp.pulse}</span>
                                        <span class="text-base text-blue-400/80 font-bold ml-2">BPM</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <button class="mt-12 bg-gradient-to-r from-indigo-500 to-indigo-600 hover:from-indigo-600 hover:to-indigo-700 text-white font-black text-2xl tracking-widest px-16 py-5 rounded-full shadow-[0_10px_20px_rgba(99,102,241,0.3)] transition-all hover:-translate-y-1 hover:shadow-[0_15px_30px_rgba(99,102,241,0.4)] active:translate-y-0" onclick="location.reload()">完成並重新開始</button>
                </div>
            `;

            contentArea.insertAdjacentHTML('afterbegin', summaryHtml);
        }


    </script>
</body>

</html>