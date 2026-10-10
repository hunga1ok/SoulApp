"""
Render authentic, high-quality guided meditation audio tracks for SoulApp.
Produces both Vietnamese (vi-VN) and English (en-US) versions with natural pacing,
breathing pauses, and delicate ambient music beds.
Includes retry logic and timeout handling.
"""

import asyncio
import os
import subprocess
import edge_tts
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
FFMPEG = BASE_DIR / "tool_bin" / "ffmpeg.exe"
OUTPUT_DIR = BASE_DIR / "assets" / "audio" / "guided"
MUSIC_DIR = BASE_DIR / "assets" / "audio" / "music"
AMBIENCE_DIR = BASE_DIR / "assets" / "audio" / "ambience"

TRACKS = [
    # Foundational daily practices (GA-01 to GA-10)
    {
        "id": "GA-01",
        "slug": "1-minute-reset",
        "bed": MUSIC_DIR / "so-14-rooted-calm.m4a",
        "bed_volume": 0.18,
        "vi_paragraphs": [
            "Dừng lại một chút.",
            "Không cần sửa chữa điều gì ngay bây giờ. Chỉ cần ở đây.",
            "Hít vào chậm qua mũi. Giữ một nhịp. Và thở ra thật nhẹ.",
            "Một lần nữa. Hít vào. Cảm nhận vai của bạn mềm xuống. Thở ra. Cho phép những gì vừa xảy ra được ở lại phía sau trong một phút.",
            "Hãy tự hỏi: Ngay lúc này, mình cần điều gì nhất? Bạn không cần có câu trả lời hoàn hảo.",
            "Chọn một từ cho phút tiếp theo: bình yên, rõ ràng, kiên nhẫn, hoặc đơn giản là có mặt.",
            "Hít vào. Thở ra.",
            "Bạn có thể bắt đầu lại từ khoảnh khắc này."
        ],
        "en_paragraphs": [
            "Pause for a moment.",
            "You do not need to fix anything right now. Just be here.",
            "Breathe in slowly through your nose. Hold for a beat. And breathe out gently.",
            "Again. Breathe in. Let your shoulders soften. Breathe out. For one minute, allow what just happened to stay behind you.",
            "Ask yourself: What do I need most right now? You do not need a perfect answer.",
            "Choose one word for the next moment: peace, clarity, patience, or simply presence.",
            "Breathe in. Breathe out.",
            "You can begin again from here."
        ]
    },
    {
        "id": "GA-02",
        "slug": "morning-arrival",
        "bed": MUSIC_DIR / "so-11-warm-felt-piano.m4a",
        "bed_volume": 0.20,
        "vi_paragraphs": [
            "Chào buổi sáng.",
            "Trước khi bước vào những tin nhắn, công việc và kế hoạch của hôm nay, hãy dành vài phút để trở về với chính mình.",
            "Hít vào thật chậm. Cảm nhận cơ thể đang thức dậy. Thở ra và để nhịp độ của buổi sáng chậm lại một chút.",
            "Hãy để ý ba điều đang hiện diện quanh bạn. Có thể là ánh sáng trong phòng, âm thanh bên ngoài cửa sổ, hay cảm giác chiếc chăn vẫn còn ấm.",
            "Bạn đang ở đây. Một ngày mới đang bắt đầu.",
            "Hãy đặt tay lên ngực hoặc bụng nếu điều đó dễ chịu với bạn. Tự hỏi: Hôm nay mình muốn xuất hiện như một người thế nào?",
            "Không phải hôm nay bạn phải làm được bao nhiêu. Mà là cách bạn muốn sống trong ngày này.",
            "Có thể là bình tĩnh. Có thể là can đảm. Có thể là tử tế với chính mình.",
            "Chọn một ý định nhỏ. Hít vào với ý định đó. Thở ra những áp lực không cần thiết.",
            "Hôm nay không cần hoàn hảo. Chỉ cần là một ngày bạn có mặt trong chính cuộc đời mình."
        ],
        "en_paragraphs": [
            "Good morning.",
            "Before messages, work, and plans begin to fill your day, take a few minutes to come back to yourself.",
            "Breathe in slowly. Notice your body waking up. Breathe out and let the morning move a little more gently.",
            "Notice three things already here with you. The light in the room, a sound beyond the window, or the warmth that still remains around you.",
            "You are here. A new day is beginning.",
            "If it feels comfortable, place a hand on your chest or your belly. Ask yourself: How do I want to show up today?",
            "Not how much you need to accomplish. How you want to live inside this day.",
            "Maybe calm. Maybe courage. Maybe kindness toward yourself.",
            "Choose one small intention. Breathe it in. Breathe out the pressure you do not need.",
            "Today does not have to be perfect. It only needs to be a day you are present in your own life."
        ]
    },
    {
        "id": "GA-03",
        "slug": "morning-gratitude",
        "bed": MUSIC_DIR / "so-13-golden-flow.m4a",
        "bed_volume": 0.20,
        "vi_paragraphs": [
            "Hãy bắt đầu bằng một hơi thở chậm.",
            "Hôm nay, bạn không cần tìm điều gì quá lớn để biết ơn. Chúng ta chỉ cần nhận ra những điều đang nâng đỡ cuộc sống của mình.",
            "Hãy nghĩ đến một điều đơn giản mà bạn đang có ngay lúc này. Một nơi để nghỉ ngơi. Một người vẫn quan tâm đến bạn. Một cơ thể đang đưa bạn qua từng ngày. Một cơ hội mà trước đây bạn từng mong muốn.",
            "Chọn điều đầu tiên xuất hiện trong tâm trí. Thầm nói: Mình biết ơn vì điều này.",
            "Và hỏi thêm: Điều này đã mang lại cho mình điều gì? Dành vài giây để cảm nhận lý do, thay vì chỉ nói ra từ biết ơn.",
            "Bây giờ nghĩ đến một người. Có thể họ đang ở bên bạn, hoặc từng đi qua cuộc đời bạn. Nhớ lại một hành động nhỏ, một lời nói, một khoảnh khắc khiến bạn thấy được quan tâm. Hãy để cảm giác ấy ở lại một chút.",
            "Cuối cùng, hãy nghĩ về một điều bạn thường xem là hiển nhiên: nước sạch, một bữa ăn, đôi chân có thể đưa bạn đi, hay một buổi sáng bình thường.",
            "Cuộc sống không cần hoàn hảo để vẫn có những điều đáng trân trọng.",
            "Trước khi kết thúc, hãy chọn một điều bạn muốn mang theo vào hôm nay. Nhẹ nhàng nói: Cảm ơn vì điều này đang có mặt trong cuộc sống của mình.",
            "Hít vào. Và bắt đầu ngày mới từ cảm giác đủ đầy của điều đang có."
        ],
        "en_paragraphs": [
            "Begin with one slow breath.",
            "Today, you do not need to find something extraordinary to be grateful for. We are simply noticing what is already supporting your life.",
            "Think of one simple thing you have right now. A place to rest. Someone who cares about you. A body carrying you through your days. An opportunity you once hoped for.",
            "Choose the first thing that comes to mind. Quietly say: I am grateful for this.",
            "Then ask: What has this given me? Take a few seconds to feel the reason, instead of only saying the word gratitude.",
            "Now think of one person. They may be in your life today, or someone who once crossed your path. Remember one small act, one sentence, one moment that made you feel cared for. Let that feeling stay for a moment.",
            "Finally, notice something you usually take for granted: clean water, a meal, feet that carry you, or simply an ordinary morning.",
            "Life does not have to be perfect for there to be something worth appreciating.",
            "Before we finish, choose one thing you want to carry into today. Gently say: Thank you for being part of my life.",
            "Breathe in, and begin your day from the fullness of what is already here."
        ]
    },
    {
        "id": "GA-04",
        "slug": "notice-what-is-good",
        "bed": MUSIC_DIR / "so-11-warm-felt-piano.m4a",
        "bed_volume": 0.20,
        "vi_paragraphs": [
            "Có những ngày điều tốt đẹp rất dễ nhìn thấy. Cũng có những ngày chúng nằm ở những nơi rất nhỏ.",
            "Hôm nay, chúng ta không ép bản thân phải thấy tích cực. Chúng ta chỉ luyện khả năng nhận ra điều tốt khi nó xuất hiện.",
            "Nhớ lại từ lúc bạn thức dậy đến bây giờ. Có khoảnh khắc nào khiến mọi thứ dễ chịu hơn một chút không? Một ly nước đúng lúc. Một tin nhắn. Một con đường ít đông. Một bữa ăn ngon. Một người mỉm cười với bạn.",
            "Chọn một khoảnh khắc. Hãy nhìn lại nó như thể bạn đang xem một tấm ảnh. Bạn ở đâu? Có âm thanh gì? Bạn cảm thấy thế nào?",
            "Bây giờ hãy nghĩ đến một điều đã diễn ra tốt hơn bạn dự đoán, dù chỉ một chút.",
            "Cuối cùng, nghĩ đến một điều bạn đã làm cho chính mình hôm nay. Có thể rất nhỏ: nghỉ đúng lúc, hoàn thành một việc, nói không, bắt đầu lại, hoặc đơn giản là vẫn tiếp tục.",
            "Hãy công nhận điều đó.",
            "Điều tốt đẹp không xoá đi phần khó khăn. Nhưng khả năng nhìn thấy cả hai giúp chúng ta sống một ngày đầy đủ hơn.",
            "Ghi lại một điều bạn muốn nhớ về hôm nay."
        ],
        "en_paragraphs": [
            "Some days, good things are easy to notice. On other days, they live in very small places.",
            "Today, we are not forcing ourselves to be positive. We are practicing the ability to notice what is good when it appears.",
            "Think back from the moment you woke up until now. Was there a moment that made the day feel a little easier? A glass of water at the right time. A message. A quieter road. A good meal. Someone smiling at you.",
            "Choose one moment. Look at it as if it were a photograph. Where were you? What could you hear? How did you feel?",
            "Now think of one thing that went slightly better than you expected.",
            "Finally, think of one thing you did for yourself today. It can be very small: resting when you needed to, finishing one task, saying no, beginning again, or simply continuing.",
            "Acknowledge it.",
            "The good does not erase what was difficult. But being able to see both can help us experience the day more fully.",
            "Write down one thing you want to remember about today."
        ]
    },
    {
        "id": "GA-05",
        "slug": "meet-your-future-self",
        "bed": MUSIC_DIR / "so-12-future-horizon.m4a",
        "bed_volume": 0.20,
        "vi_paragraphs": [
            "Hãy tìm một tư thế thoải mái. Bạn không cần nhìn thấy hình ảnh thật rõ. Chỉ cần cho phép trí tưởng tượng mở ra theo cách tự nhiên nhất.",
            "Hít vào chậm. Thở ra.",
            "Hãy tưởng tượng một ngày trong tương lai. Không cần biết chính xác là ngày nào. Chỉ cần đủ xa để bạn đã có thời gian trưởng thành thành phiên bản mà mình đang hướng tới.",
            "Bạn thức dậy ở đâu? Không gian quanh bạn có cảm giác như thế nào? Ánh sáng, màu sắc, âm thanh của buổi sáng ấy ra sao?",
            "Quan sát phiên bản tương lai của bạn bắt đầu ngày mới. Cách họ bước đi. Cách họ nói với chính mình. Điều gì dường như đã trở nên nhẹ nhàng hơn?",
            "Bây giờ hãy nhìn vào một lĩnh vực quan trọng với bạn: công việc, tình yêu, sức khỏe, gia đình, tài chính, hoặc sự bình yên bên trong.",
            "Không cần tưởng tượng một cuộc đời hoàn hảo. Hãy nhìn một cuộc đời phù hợp hơn với điều bạn thực sự coi trọng.",
            "Phiên bản tương lai ấy đã học được điều gì mà bạn hôm nay vẫn đang học? Họ đã ngừng làm điều gì? Họ làm điều nhỏ nào một cách đều đặn?",
            "Hãy tưởng tượng bạn ngồi xuống cạnh phiên bản đó. Bạn không cần hỏi cách đạt được tất cả mọi thứ. Chỉ hỏi một câu: Bước nhỏ tiếp theo của mình là gì?",
            "Đừng ép một câu trả lời xuất hiện. Có thể đó là một hành động. Một cuộc trò chuyện. Một giới hạn. Một thói quen. Một sự nghỉ ngơi.",
            "Khi đã sẵn sàng, hãy quay trở lại với hơi thở.",
            "Tương lai không được tạo nên trong một khoảnh khắc duy nhất. Nó được xây bằng những lựa chọn nhỏ lặp lại.",
            "Ghi lại điều bạn vừa nhận ra và chọn một bước mà bạn có thể làm trong hôm nay."
        ],
        "en_paragraphs": [
            "Find a comfortable position. You do not need to see everything clearly. Let your imagination open in whatever way feels natural.",
            "Breathe in slowly. Breathe out.",
            "Imagine a day in your future. You do not need to know the exact date. Only far enough ahead that you have had time to grow into the person you are becoming.",
            "Where do you wake up? What does the space around you feel like? What is the light, color, and sound of that morning?",
            "Notice your future self beginning the day. The way they move. The way they speak to themselves. What seems to have become lighter?",
            "Now look at one area that matters to you: work, love, health, family, money, or inner peace.",
            "You do not need to picture a perfect life. Picture a life that feels more aligned with what you truly value.",
            "What has this future version of you learned that you are still learning today? What have they stopped doing? What small thing do they do consistently?",
            "Imagine sitting beside them. You do not need to ask how to achieve everything. Ask only: What is my next small step?",
            "Do not force an answer. It may be an action, a conversation, a boundary, a habit, or rest.",
            "When you are ready, return to your breath.",
            "Your future is not created in one dramatic moment. It is built through small choices repeated over time.",
            "Write down what you noticed and choose one step you can take today."
        ]
    },
    {
        "id": "GA-06",
        "slug": "your-ideal-day",
        "bed": MUSIC_DIR / "so-16-open-sky-handpan.m4a",
        "bed_volume": 0.20,
        "vi_paragraphs": [
            "Hôm nay, hãy tưởng tượng không phải một cuộc đời hoàn hảo, mà là một ngày khiến bạn cảm thấy mình đang sống đúng hơn với điều mình muốn.",
            "Buổi sáng bắt đầu thế nào? Bạn thức dậy lúc mấy giờ? Điều đầu tiên bạn nhìn thấy là gì? Bạn có vội vàng không, hay có một khoảng nhỏ dành cho chính mình?",
            "Tiếp tục đi qua ngày đó. Bạn đang làm công việc gì? Không nhất thiết là chức danh. Hãy chú ý cảm giác: bạn đang tập trung, sáng tạo, kết nối, hay tự do?",
            "Ai xuất hiện trong ngày của bạn? Bạn muốn các mối quan hệ ấy mang lại cảm giác gì?",
            "Bạn chăm sóc cơ thể như thế nào? Bạn ăn, di chuyển, nghỉ và thở ra sao?",
            "Khi ngày kết thúc, điều gì khiến bạn nghĩ: Hôm nay là một ngày đáng sống?",
            "Bây giờ nhìn lại. Trong ngày lý tưởng đó, có điều nào bạn có thể đưa vào cuộc sống hiện tại chỉ với 10 phút?",
            "Một bữa sáng chậm hơn. Một cuộc đi bộ. Một giờ không cầm điện thoại. Một lời nhắn cho người mình yêu. Hai mươi phút cho dự án quan trọng.",
            "Vision không chỉ để nhìn. Nó giúp chúng ta nhận ra điều gì có thể bắt đầu ngay bây giờ.",
            "Chọn một mảnh nhỏ của ngày lý tưởng và mang nó vào hôm nay."
        ],
        "en_paragraphs": [
            "Today, imagine not a perfect life, but a day that feels more aligned with the way you want to live.",
            "How does the morning begin? What time do you wake up? What is the first thing you see? Are you rushing, or is there a small pocket of time that belongs to you?",
            "Move through the day. What kind of work are you doing? You do not need a job title. Notice the feeling: focused, creative, connected, free?",
            "Who appears in your day? How do you want those relationships to feel?",
            "How are you caring for your body? How do you eat, move, rest, and breathe?",
            "As the day ends, what makes you think, This was a day worth living?",
            "Now look back. Is there one part of that ideal day you could bring into your current life with only ten minutes?",
            "A slower breakfast. A walk. One phone-free hour. A message to someone you love. Twenty minutes for a meaningful project.",
            "A vision is not only something to look at. It helps us notice what can begin now.",
            "Choose one small piece of your ideal day and bring it into today."
        ]
    },
    {
        "id": "GA-07",
        "slug": "quiet-confidence",
        "bed": MUSIC_DIR / "so-19-quiet-momentum.m4a",
        "bed_volume": 0.20,
        "vi_paragraphs": [
            "Tự tin không phải lúc nào cũng có cảm giác mạnh mẽ. Đôi khi nó chỉ là quyết định không rời bỏ chính mình khi chưa chắc chắn.",
            "Hít vào. Nhớ lại một việc bạn từng nghĩ mình không làm được, nhưng cuối cùng bạn đã học được cách làm.",
            "Có thể bạn không làm hoàn hảo. Nhưng bạn đã tiến bộ bằng cách thử, sai, điều chỉnh và tiếp tục. Đó cũng là bằng chứng về bạn.",
            "Bây giờ nghĩ đến một điều bạn đang muốn làm nhưng vẫn còn ngại, sợ hoặc nghi ngờ.",
            "Thay vì hỏi mình có đủ giỏi không, hãy thử hỏi: Mình có sẵn sàng học bước tiếp theo không?",
            "Bạn không cần cảm thấy tự tin hoàn toàn trước khi hành động. Nhiều khi sự tự tin đến sau khi bạn đã hành động vài lần.",
            "Thầm nhắc: Mình có thể chưa biết hết. Nhưng mình có thể học. Mình có thể hỏi. Mình có thể thử lại.",
            "Hãy nghĩ về một hành động nhỏ sẽ khiến bạn tôn trọng bản thân hơn vào cuối ngày. Chọn nó.",
            "Hít vào. Thở ra. Không cần trở thành một người khác. Hôm nay chỉ cần đứng về phía chính mình."
        ],
        "en_paragraphs": [
            "Confidence does not always feel powerful. Sometimes it is simply the decision not to abandon yourself when you are uncertain.",
            "Breathe in. Remember something you once thought you could not do, but eventually learned.",
            "Maybe you never did it perfectly. But you improved by trying, making mistakes, adjusting, and continuing. That is evidence about you, too.",
            "Now think of something you want to do but still feel hesitant, afraid, or unsure about.",
            "Instead of asking, Am I good enough?, try asking: Am I willing to learn the next step?",
            "You do not need to feel completely confident before acting. Often, confidence arrives after you have acted a few times.",
            "Remind yourself: I may not know everything yet. I can learn. I can ask. I can try again.",
            "Think of one small action that would make you respect yourself a little more by the end of today. Choose it.",
            "Breathe in. Breathe out. You do not need to become someone else. Today, simply stay on your own side."
        ]
    },
    {
        "id": "GA-08",
        "slug": "soft-self-love",
        "bed": MUSIC_DIR / "so-18-heart-space.m4a",
        "bed_volume": 0.22,
        "vi_paragraphs": [
            "Hãy để vài phút này không phải là lúc bạn cố trở nên tốt hơn. Chỉ là lúc bạn ngừng đối xử với mình như một dự án cần sửa.",
            "Hít vào chậm. Hãy nhận ra cơ thể bạn đang ở đây, đã đưa bạn qua rất nhiều ngày mà không ai khác có thể sống thay bạn.",
            "Có thể bạn có những điều về mình chưa hài lòng. Điều đó không ngăn bạn đối xử với bản thân bằng sự tôn trọng ngay hôm nay.",
            "Hãy nghĩ về cách bạn sẽ nói chuyện với một người bạn đang mệt mỏi, thất vọng hoặc chưa đạt được điều họ muốn. Bạn có thể không nói với họ những câu gay gắt mà bạn thường nói với chính mình.",
            "Bây giờ thử dành cùng một chất giọng đó cho bản thân.",
            "Mình đang học. Mình được phép mệt. Mình vẫn có giá trị ngay cả trong những ngày không hiệu quả. Mình có thể vừa muốn phát triển, vừa trân trọng con người hiện tại.",
            "Chọn một điều cơ thể hoặc tâm trí bạn cần trong hôm nay. Nước. Thức ăn. Nghỉ ngơi. Một cuộc trò chuyện. Một ranh giới. Một khoảng yên tĩnh.",
            "Yêu bản thân không nhất thiết là cảm giác. Đôi khi nó là một hành động chăm sóc rất nhỏ. Hãy chọn một hành động đó cho hôm nay."
        ],
        "en_paragraphs": [
            "Let these few minutes be a time when you are not trying to become better. Just a time when you stop treating yourself like a project that constantly needs fixing.",
            "Breathe in slowly. Notice that your body is here, carrying you through days no one else can live for you.",
            "There may be things about yourself you are still working on. That does not prevent you from treating yourself with respect today.",
            "Think about how you would speak to a friend who was tired, disappointed, or not yet where they wanted to be. You might not use the same harsh words you sometimes use with yourself.",
            "Now offer yourself that same tone.",
            "I am learning. I am allowed to be tired. My worth is not measured by how productive I am today. I can want to grow and still appreciate who I am now.",
            "Choose one thing your body or mind needs today. Water. Food. Rest. A conversation. A boundary. A little quiet.",
            "Self-love does not always have to be a feeling. Sometimes it is one small act of care. Choose that act for today."
        ]
    },
    {
        "id": "GA-09",
        "slug": "evening-release",
        "bed": AMBIENCE_DIR / "so-03-window-rain.m4a",
        "bed_volume": 0.20,
        "vi_paragraphs": [
            "Ngày hôm nay sắp kết thúc. Bạn không cần mang mọi thứ của hôm nay vào ngày mai.",
            "Hít vào. Thở ra dài hơn một chút.",
            "Nhớ lại một điều khiến bạn thấy nặng lòng hôm nay. Không cần phân tích lại toàn bộ. Chỉ cần gọi tên nó.",
            "Điều này đã khó với mình. Cho phép câu đó đủ.",
            "Bây giờ nhớ lại một việc bạn đã làm tốt, dù nhỏ. Một việc bạn hoàn thành. Một lần bạn kiên nhẫn hơn. Một khoảnh khắc bạn chăm sóc ai đó hoặc chăm sóc mình. Ghi nhận nó.",
            "Tiếp theo, hỏi: Có điều gì hôm nay mình không thể kiểm soát nhưng vẫn đang cố giữ lại không?",
            "Nếu có, hãy tưởng tượng đặt nó xuống cạnh mình, chỉ trong đêm nay. Bạn có thể quay lại với nó khi cần. Không nhất thiết phải giải quyết ngay lúc này.",
            "Cuối cùng, chọn một điều khiến hôm nay vẫn đáng nhớ. Một tiếng cười. Một bữa ăn. Một người. Một nỗ lực. Một khoảnh khắc yên tĩnh.",
            "Thầm nói: Hôm nay đã đủ. Mình được phép nghỉ.",
            "Thở ra và để ngày này khép lại."
        ],
        "en_paragraphs": [
            "Today is coming to an end. You do not need to carry every part of it into tomorrow.",
            "Breathe in. Let your exhale be a little longer.",
            "Remember one thing that felt heavy today. You do not need to analyze the whole story again. Just name it.",
            "This was hard for me. Let that sentence be enough.",
            "Now remember one thing you did well, however small. Something you completed. A moment you were more patient. A moment you cared for someone or cared for yourself. Acknowledge it.",
            "Next ask: Is there something I could not control today that I am still trying to hold?",
            "If there is, imagine setting it down beside you, just for tonight. You can return to it when you need to. You do not have to solve it right now.",
            "Finally, choose one thing that still made today worth remembering. A laugh. A meal. A person. An effort. A quiet moment.",
            "Say to yourself: Today was enough. I am allowed to rest.",
            "Breathe out and let the day close."
        ]
    },
    {
        "id": "GA-10",
        "slug": "gratitude-before-sleep",
        "bed": AMBIENCE_DIR / "so-10-soft-sound-bath.m4a",
        "bed_volume": 0.22,
        "vi_paragraphs": [
            "Nằm xuống thật thoải mái. Không cần cố gắng để ngủ ngay. Chỉ cần cho cơ thể biết rằng hôm nay đã kết thúc.",
            "Hít vào nhẹ. Thở ra chậm.",
            "Hãy nghĩ về một điều nhỏ đã giúp bạn trong ngày hôm nay. Có thể ai đó đã trả lời một tin nhắn. Có thể bạn có một bữa ăn ấm. Có thể bạn đã đến nơi an toàn. Thầm nói lời cảm ơn cho điều đó.",
            "Bây giờ nghĩ đến cơ thể mình. Có một phần nào đã làm việc cho bạn cả ngày mà bạn thường quên? Đôi mắt. Bàn tay. Đôi chân. Hơi thở. Chỉ cần nhận ra: cơ thể này đã ở bên bạn suốt hôm nay.",
            "Tiếp theo, nhớ lại khoảnh khắc dễ chịu nhất trong ngày. Không cần phải đặc biệt. Hãy để hình ảnh đó xuất hiện một lần nữa.",
            "Nếu hôm nay là một ngày khó khăn, bạn không cần biến nó thành một ngày tốt. Chỉ cần công nhận rằng bạn đã đi đến tận đây. Thầm nói: Cảm ơn mình vì đã tiếp tục.",
            "Bây giờ bạn không cần nghĩ thêm về ngày mai. Những việc chưa xong có thể chờ đến sáng.",
            "Hít vào. Thở ra.",
            "Cảm ơn ngày hôm nay vì những gì nó đã cho bạn, cả những điều dễ chịu và những điều giúp bạn học thêm về mình.",
            "Đêm nay, bạn được phép nghỉ."
        ],
        "en_paragraphs": [
            "Make yourself comfortable. You do not need to force sleep. Simply let your body know that today is over.",
            "Breathe in gently. Breathe out slowly.",
            "Think of one small thing that helped you today. Maybe someone answered a message. Maybe you had a warm meal. Maybe you arrived somewhere safely. Quietly offer thanks for that.",
            "Now think of your body. Is there one part that worked for you all day that you usually forget? Your eyes. Your hands. Your feet. Your breath. Simply notice: this body stayed with you through today.",
            "Next, remember the most pleasant moment of your day. It does not have to be special. Let the image return once more.",
            "If today was difficult, you do not need to turn it into a good day. Simply acknowledge that you made it here. Say quietly: Thank you to myself for continuing.",
            "You do not need to think about tomorrow right now. What is unfinished can wait until morning.",
            "Breathe in. Breathe out.",
            "Thank this day for what it gave you, both what felt good and what helped you learn more about yourself.",
            "Tonight, you are allowed to rest."
        ]
    },

    # Vision sessions (GA-18 to GA-31)
    {
        "id": "GA-18",
        "slug": "step-into-your-future",
        "bed": MUSIC_DIR / "so-12-future-horizon.m4a",
        "bed_volume": 0.20,
        "vi_paragraphs": [
            "Hãy dành một khoảnh khắc để lắng đọng.",
            "Nhìn về phiên bản tương lai mà bạn đang từng ngày trở thành.",
            "Bạn không cần phải biết chính xác từng ngã rẽ trên con đường.",
            "Chỉ cần để lòng mình thấy rõ hơn nhịp sống, những mối quan hệ chân thành, và công việc ý nghĩa mà bạn đang hướng tới.",
            "Cảm nhận sự vững vàng và tự tin trong từng hơi thở.",
            "Và bây giờ, hãy trở về với ngày hôm nay.",
            "Bắt đầu bằng một bước đi nhỏ, cụ thể, và trọn vẹn trong tầm tay bạn."
        ],
        "en_paragraphs": [
            "Take a quiet moment to settle in.",
            "Look toward the future self you are becoming each day.",
            "You do not need to know every twist and turn of the path.",
            "Simply let yourself see more clearly the rhythm of life, the meaningful connections, and the fulfilling work you are moving toward.",
            "Feel the quiet strength and clarity within each breath.",
            "And now, return to this present day.",
            "Begin with one small, concrete step that is fully within your reach."
        ]
    },
    {
        "id": "GA-21",
        "slug": "my-financial-future",
        "bed": MUSIC_DIR / "so-15-abundance-current.m4a",
        "bed_volume": 0.20,
        "vi_paragraphs": [
            "Hít một hơi thở thật sâu và thở ra nhẹ nhàng.",
            "Hãy hình dung một tương lai tài chính rộng mở và an tâm hơn.",
            "Nơi bạn có thêm nhiều lựa chọn, thêm sự bình tĩnh, và có đủ nguồn lực để chăm sóc những điều thực sự quan trọng.",
            "Hãy mở lòng đón nhận những cơ hội mới, những ý tưởng sáng tạo, và công việc phù hợp với giá trị sống của bạn.",
            "Sự thịnh vượng bắt đầu từ tư duy biết ơn và những quyết định tỉnh thức.",
            "Ngay hôm nay, chỉ một bước đi nhỏ cũng đã định hình cả một hướng đi tốt đẹp."
        ],
        "en_paragraphs": [
            "Take a deep, slow breath, and release any tension as you exhale.",
            "Picture a financial future filled with ease, stability, and freedom.",
            "A place where you have room to care for what truly matters, and the steadiness to make wise decisions.",
            "Stay open to new opportunities, inspiring ideas, and work that aligns with your core values.",
            "Abundance begins with gratitude and conscious, intentional choices.",
            "Even one small step today sets the direction for your future."
        ]
    },
    {
        "id": "GA-23",
        "slug": "open-to-healthy-love",
        "bed": MUSIC_DIR / "so-18-heart-space.m4a",
        "bed_volume": 0.22,
        "vi_paragraphs": [
            "Đặt một tay lên ngực và cảm nhận nhịp đập ấm áp của trái tim.",
            "Hãy cho phép bản thân hình dung về một tình yêu lành mạnh và bền vững.",
            "Một không gian tràn ngập sự an toàn, tôn trọng lẫn nhau, ấm áp và chân thành.",
            "Bạn không cần phải đoán trước ai sẽ bước đến hay khi nào.",
            "Chỉ cần nhận ra cách bạn xứng đáng được yêu thương, và cách bạn muốn có mặt bằng cả sự tử tế trong một mối quan hệ.",
            "Mở rộng trái tim và đón nhận yêu thương tự nhiên."
        ],
        "en_paragraphs": [
            "Place a hand gently on your heart, and feel its steady, warm beat.",
            "Allow yourself to imagine the presence of healthy, authentic love.",
            "A safe harbor defined by mutual respect, deep warmth, and honesty.",
            "You do not need to guess who will arrive, or exactly when.",
            "Simply recognize how you deserve to be loved, and how you wish to show up with kindness in a caring relationship.",
            "Open your heart, and trust in the love that is meant for you."
        ]
    },
    {
        "id": "GA-25",
        "slug": "future-career-self",
        "bed": MUSIC_DIR / "so-19-quiet-momentum.m4a",
        "bed_volume": 0.20,
        "vi_paragraphs": [
            "Hít vào sự tự tin và thở ra những hoài nghi.",
            "Hãy bước vào một ngày làm việc bình thường của phiên bản tương lai.",
            "Bạn đang tạo ra những giá trị gì? Làm việc cùng những ai? Và sử dụng tài năng của mình với sự tự tin ra sao?",
            "Không cần mọi thứ phải hoàn hảo ngay lập tức.",
            "Hành trình vĩ đại luôn bắt đầu từ sự kiên trì mỗi ngày.",
            "Hãy chọn một kỹ năng cần trau dồi, một cuộc trò chuyện cần bắt đầu, hoặc một hành động cụ thể để thực hiện hôm nay."
        ],
        "en_paragraphs": [
            "Breathe in quiet confidence, and release self-doubt as you exhale.",
            "Step into an ordinary, productive workday of your future self.",
            "What meaningful value are you creating? Who are you collaborating with? And which strengths are you using with ease?",
            "It does not have to be flawless right away.",
            "Every significant journey is built on steady, daily commitment.",
            "Choose one skill to refine, one important conversation, or one dedicated action you can begin today."
        ]
    },
    {
        "id": "GA-27",
        "slug": "a-body-i-care-for",
        "bed": AMBIENCE_DIR / "so-10-soft-sound-bath.m4a",
        "bed_volume": 0.22,
        "vi_paragraphs": [
            "Thả lỏng toàn bộ cơ thể, từ đỉnh đầu xuống đến các đầu ngón chân.",
            "Hãy trở về với thân thể của bạn bằng sự trân trọng và biết ơn sâu sắc.",
            "Nhận ra tất cả những điều kỳ diệu mà cơ thể đang lặng lẽ làm việc để nâng đỡ bạn mỗi ngày.",
            "Bạn không cần phải thay đổi mọi thứ ngay bây giờ.",
            "Chỉ cần lắng nghe cơ thể đang cần gì: một ngụm nước ấm, một khoảng nghỉ ngơi, hay một hơi thở sâu.",
            "Hãy đối đãi với cơ thể bằng sự dịu dàng và tử tế nhất."
        ],
        "en_paragraphs": [
            "Release all tension throughout your body, from head to toe.",
            "Return to your physical body with deep respect and gratitude.",
            "Notice all the quiet wonders your body performs every single day to carry you through life.",
            "You do not need to change everything at once.",
            "Simply listen to what your body needs right now: a sip of warm water, a restful pause, or an easy deep breath.",
            "Treat your body with gentleness and enduring kindness."
        ]
    },
    {
        "id": "GA-28",
        "slug": "come-home-to-your-future",
        "bed": MUSIC_DIR / "so-14-rooted-calm.m4a",
        "bed_volume": 0.20,
        "vi_paragraphs": [
            "Hít thở thật chậm và cảm nhận không gian quanh bạn.",
            "Hãy bước vào ngôi nhà tương lai của bạn qua từng chi tiết dịu êm: ánh nắng chan hòa, bầu không khí trong lành, và những thanh âm bình yên.",
            "Nơi có những người bạn yêu thương và những góc nhỏ nuôi dưỡng tâm hồn.",
            "Điều quý giá nhất không nằm ở sự xa hoa, mà là cảm giác bình yên, an toàn và thuộc về.",
            "Hôm nay, bạn có thể mang một chút cảm giác ấm áp và bình yên ấy vào không gian sống hiện tại của mình."
        ],
        "en_paragraphs": [
            "Breathe slowly, and feel the space surrounding you.",
            "Step into your future home through gentle sensory details: soft sunlight, fresh air, and calming sounds.",
            "A haven filled with the people you cherish and peaceful corners that nourish your spirit.",
            "What matters most is not luxury, but the profound sense of safety and belonging.",
            "Notice how you can bring a touch of that warmth and sanctuary into your living space today."
        ]
    },
    {
        "id": "GA-29",
        "slug": "a-life-with-more-wonder",
        "bed": MUSIC_DIR / "so-16-open-sky-handpan.m4a",
        "bed_volume": 0.20,
        "vi_paragraphs": [
            "Hãy mở rộng lồng ngực và đón nhận nguồn năng lượng tươi mới.",
            "Hình dung một cuộc sống tràn đầy sự tò mò, tự do khám phá và những chân trời rộng mở.",
            "Bạn đang đặt chân đến những vùng đất nào, học hỏi những điều mới mẻ ra sao, và cảm nhận tâm hồn mình rộng mở đến nhường nào?",
            "Thế giới luôn chứa chan những điều kỳ diệu chờ đón bạn.",
            "Hãy đưa ước mơ ấy đến gần hơn bằng một bước đi thực tế: tìm hiểu thông tin, lập kế hoạch, hoặc thử một trải nghiệm mới mẻ trong tuần này."
        ],
        "en_paragraphs": [
            "Expand your chest and welcome fresh, vibrant energy.",
            "Imagine a life filled with wonder, curiosity, and boundless discovery.",
            "Where are you traveling, what new perspectives are you learning, and how expansive does your spirit feel?",
            "The world is full of beauty waiting to be explored.",
            "Bring that vision closer with one practical step: learn something new, plan ahead, or schedule a fresh experience this week."
        ]
    },
    {
        "id": "GA-30",
        "slug": "a-home-between-us",
        "bed": MUSIC_DIR / "so-11-warm-felt-piano.m4a",
        "bed_volume": 0.22,
        "vi_paragraphs": [
            "Hãy lắng đọng tâm trí và nhớ về những người thân yêu.",
            "Cảm nhận sự gắn kết ấm áp và tình thân giữa các thành viên trong gia đình.",
            "Một tổ ấm đích thực là nơi có sự lắng nghe, sự thấu hiểu, và đủ bao dung để mỗi người được trọn vẹn là chính mình.",
            "Bạn luôn có thể thắp lên ngọn lửa ấm áp trong gia đình.",
            "Bằng một lời hỏi thăm chân thành, một nụ cười, hay đơn giản là sự hiện diện trọn vẹn bên cạnh những người bạn yêu thương."
        ],
        "en_paragraphs": [
            "Rest your mind and remember the people you hold dear.",
            "Feel the comforting warmth and deep connection shared with your family and loved ones.",
            "A true home is built on patient listening, empathy, and unconditional acceptance for each person to be themselves.",
            "You can always kindle that warmth in your relationships.",
            "Through a caring message, an attentive smile, or simply your mindful presence with those you love."
        ]
    },
    {
        "id": "GA-31",
        "slug": "return-to-yourself",
        "bed": MUSIC_DIR / "so-14-rooted-calm.m4a",
        "bed_volume": 0.20,
        "vi_paragraphs": [
            "Trong những phút giây này, bạn không cần phải cố gắng trở thành ai khác.",
            "Hãy buông bỏ mọi trách nhiệm và kỳ vọng sang một bên.",
            "Nhận biết hơi thở tự nhiên đang ra vào nhẹ nhàng. Cảm nhận sự tĩnh lặng trong căn phòng và trong tâm hồn.",
            "Bạn không cần phải giải quyết tất cả mọi việc ngay lúc này.",
            "Chỉ cần quay về nương tựa nơi chính mình.",
            "Bình yên, dịu dàng, và trọn vẹn đủ đầy."
        ],
        "en_paragraphs": [
            "In these quiet moments, you do not need to be anyone else.",
            "Set aside all expectations, demands, and hurried thoughts.",
            "Simply notice your natural breath flowing in and out. Feel the stillness in the room and within your spirit.",
            "You do not have to solve everything right now.",
            "Return to yourself, rest in this present stillness.",
            "Peaceful, gentle, and completely whole."
        ]
    }
]

async def render_single_paragraph(text, voice, rate, pitch, out_path, retries=5):
    for attempt in range(retries):
        try:
            comm = edge_tts.Communicate(
                text,
                voice,
                rate=rate,
                pitch=pitch,
                connect_timeout=20,
                receive_timeout=30
            )
            await asyncio.wait_for(comm.save(str(out_path)), timeout=40.0)
            if out_path.exists() and out_path.stat().st_size > 0:
                return
        except Exception as e:
            if attempt == retries - 1:
                raise
            await asyncio.sleep(2.0 * (attempt + 1))

async def render_track_voice(paragraphs, voice, rate="-15%", pitch="-2Hz", pause_sec=2.5, temp_prefix="tmp"):
    wav_segments = []
    temp_files = []
    try:
        for idx, p in enumerate(paragraphs):
            mp3_seg = Path(f"{temp_prefix}_seg_{idx:02d}.mp3")
            wav_seg = Path(f"{temp_prefix}_seg_{idx:02d}.wav")
            await render_single_paragraph(p, voice, rate, pitch, mp3_seg)
            temp_files.append(mp3_seg)
            subprocess.run([
                str(FFMPEG), "-y",
                "-i", str(mp3_seg),
                "-af", "afade=t=in:ss=0:d=0.015,areverse,afade=t=in:ss=0:d=0.015,areverse",
                "-ar", "44100",
                "-ac", "2",
                "-c:a", "pcm_s16le",
                str(wav_seg)
            ], capture_output=True, check=True)
            wav_segments.append(wav_seg)
            temp_files.append(wav_seg)

        silence_file = Path(f"{temp_prefix}_silence.wav")
        temp_files.append(silence_file)
        subprocess.run([
            str(FFMPEG), "-y",
            "-f", "lavfi", "-i", "anullsrc=r=44100:cl=stereo",
            "-t", str(pause_sec),
            "-c:a", "pcm_s16le",
            str(silence_file)
        ], capture_output=True, check=True)

        concat_list = Path(f"{temp_prefix}_list.txt")
        temp_files.append(concat_list)
        with open(concat_list, "w", encoding="utf-8") as f:
            for idx, sf in enumerate(wav_segments):
                f.write(f"file '{sf.resolve().as_posix()}'\n")
                if idx < len(wav_segments) - 1:
                    f.write(f"file '{silence_file.resolve().as_posix()}'\n")

        full_voice = Path(f"{temp_prefix}_voice_full.wav")
        subprocess.run([
            str(FFMPEG), "-y",
            "-f", "concat", "-safe", "0",
            "-i", str(concat_list),
            "-c:a", "pcm_s16le",
            str(full_voice)
        ], capture_output=True, check=True)

        return full_voice
    finally:
        for sf in temp_files:
            if sf.exists():
                try:
                    sf.unlink()
                except Exception:
                    pass

def mix_voice_and_bed(voice_file, bed_file, bed_vol, output_file):
    cmd = [
        str(FFMPEG), "-y",
        "-i", str(voice_file),
        "-stream_loop", "-1", "-i", str(bed_file),
        "-filter_complex",
        f"[0:a]volume=1.0[v];[1:a]volume={bed_vol:.2f}[b];[v][b]amix=inputs=2:duration=first:dropout_transition=2,alimiter=limit=0.92:attack=5:release=50[outa]",
        "-map", "[outa]",
        "-vn",
        "-c:a", "aac",
        "-b:a", "128k",
        "-ar", "44100",
        str(output_file)
    ]
    subprocess.run(cmd, capture_output=True, check=True)
    if voice_file.exists():
        try:
            voice_file.unlink()
        except Exception:
            pass

async def render_all(skip_existing=True):
    print("=== Starting Rendering Guided Meditation Voices for SoulApp ===")
    vi_out_dir = OUTPUT_DIR / "vi"
    en_out_dir = OUTPUT_DIR / "en"
    vi_out_dir.mkdir(parents=True, exist_ok=True)
    en_out_dir.mkdir(parents=True, exist_ok=True)

    for i, t in enumerate(TRACKS, 1):
        code = t["id"].lower()
        slug = t["slug"]
        print(f"\n[{i}/{len(TRACKS)}] Processing {t['id']} - {slug}...")

        # 1. Vietnamese
        vi_out = vi_out_dir / f"{code}-{slug}.m4a"
        if skip_existing and vi_out.exists() and vi_out.stat().st_size > 200000:
            print(f"  -> Skipping VI (already rendered): {vi_out.name}")
        else:
            print(f"  -> Rendering VI: {vi_out.name}")
            vi_voice = await render_track_voice(
                t["vi_paragraphs"],
                voice="fr-FR-VivienneMultilingualNeural",
                rate="-10%",
                pitch="+0Hz",
                pause_sec=2.8,
                temp_prefix=f"tmp_vi_{code}"
            )
            mix_voice_and_bed(vi_voice, t["bed"], t["bed_volume"], vi_out)
            print(f"     Done VI! Size: {vi_out.stat().st_size:,} bytes")

        # 2. English
        en_out = en_out_dir / f"{code}-{slug}.m4a"
        if skip_existing and en_out.exists() and en_out.stat().st_size > 200000:
            print(f"  -> Skipping EN (already rendered): {en_out.name}")
        else:
            print(f"  -> Rendering EN: {en_out.name}")
            en_voice = await render_track_voice(
                t["en_paragraphs"],
                voice="en-US-AvaNeural",
                rate="-15%",
                pitch="-2Hz",
                pause_sec=2.8,
                temp_prefix=f"tmp_en_{code}"
            )
            mix_voice_and_bed(en_voice, t["bed"], t["bed_volume"], en_out)
            print(f"     Done EN! Size: {en_out.stat().st_size:,} bytes")

    print("\n=== All Guided Audio Tracks Rendered Successfully! ===")

if __name__ == "__main__":
    asyncio.run(render_all(skip_existing=True))
