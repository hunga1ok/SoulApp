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

async def render_single_paragraph(text, voice, rate, pitch, out_path, retries=3):
    for attempt in range(retries):
        try:
            comm = edge_tts.Communicate(
                text,
                voice,
                rate=rate,
                pitch=pitch,
                connect_timeout=15,
                receive_timeout=25
            )
            await asyncio.wait_for(comm.save(str(out_path)), timeout=30.0)
            if out_path.exists() and out_path.stat().st_size > 0:
                return
        except Exception as e:
            if attempt == retries - 1:
                raise
            await asyncio.sleep(1.0)

async def render_track_voice(paragraphs, voice, rate="-15%", pitch="-2Hz", pause_sec=2.5, temp_prefix="tmp"):
    temp_files = []
    for idx, p in enumerate(paragraphs):
        seg_file = Path(f"{temp_prefix}_seg_{idx:02d}.mp3")
        await render_single_paragraph(p, voice, rate, pitch, seg_file)
        temp_files.append(seg_file)

    silence_file = Path(f"{temp_prefix}_silence.mp3")
    subprocess.run([
        str(FFMPEG), "-y",
        "-f", "lavfi", "-i", "anullsrc=r=24000:cl=mono",
        "-t", str(pause_sec),
        "-c:a", "libmp3lame", "-b:a", "48k",
        str(silence_file)
    ], capture_output=True, check=True)

    concat_list = Path(f"{temp_prefix}_list.txt")
    with open(concat_list, "w", encoding="utf-8") as f:
        for idx, sf in enumerate(temp_files):
            f.write(f"file '{sf.name}'\n")
            if idx < len(temp_files) - 1:
                f.write(f"file '{silence_file.name}'\n")

    full_voice = Path(f"{temp_prefix}_voice_full.mp3")
    subprocess.run([
        str(FFMPEG), "-y",
        "-f", "concat", "-safe", "0",
        "-i", str(concat_list),
        "-c", "copy",
        str(full_voice)
    ], capture_output=True, check=True)

    # Cleanup segments
    for sf in temp_files + [silence_file, concat_list]:
        if sf.exists():
            sf.unlink()

    return full_voice

def mix_voice_and_bed(voice_file, bed_file, bed_vol, output_file):
    cmd = [
        str(FFMPEG), "-y",
        "-i", str(voice_file),
        "-stream_loop", "-1", "-i", str(bed_file),
        "-filter_complex",
        f"[0:a]volume=1.0[v];[1:a]volume={bed_vol:.2f}[b];[v][b]amix=inputs=2:duration=first:dropout_transition=2[outa]",
        "-map", "[outa]",
        "-vn",
        "-c:a", "aac",
        "-b:a", "128k",
        str(output_file)
    ]
    subprocess.run(cmd, capture_output=True, check=True)
    if voice_file.exists():
        voice_file.unlink()

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
                voice="vi-VN-HoaiMyNeural",
                rate="-15%",
                pitch="-2Hz",
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
