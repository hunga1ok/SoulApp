"""
Generate custom ambient/music soundscapes and spoken guided audio tracks
for the new Comfort Zone spaces:
- SO-21: Christmas in a Gryffindor Private Room (528 Hz Magical Hearth & Chimes)
- SO-22: Autumn Thanksgiving (639 Hz Warm Harvest Acoustic & Breeze)
- SO-23: A Peaceful Tết Morning (432 Hz Spring Morning Melody & Birdsong)
- GA-32: Lời mẹ dịu dàng đánh thức buổi sáng / A Mother's Gentle Morning Greeting
- GA-33: Đêm Giáng Sinh trong tháp cổ ấm áp / Christmas Night in the Tower Sanctuary
- GA-34: Chiều thu biết ơn & Đủ đầy / Autumn Evening of Gratitude
"""

import asyncio
import subprocess
from pathlib import Path
import edge_tts

BASE_DIR = Path(__file__).resolve().parent.parent
FFMPEG = BASE_DIR / "tool_bin" / "ffmpeg.exe"
if not FFMPEG.exists():
    FFMPEG = Path("ffmpeg")

MUSIC_DIR = BASE_DIR / "assets" / "audio" / "music"
GUIDED_DIR = BASE_DIR / "assets" / "audio" / "guided"


def generate_music_beds():
    MUSIC_DIR.mkdir(parents=True, exist_ok=True)

    # 1. SO-21: 528 Hz Magical Gryffindor Hearth & Winter Chimes
    so21 = MUSIC_DIR / "so-21-gryffindor-hearth-chimes.m4a"
    if not so21.exists():
        print("Generating SO-21 (528 Hz Gryffindor Hearth & Chimes)...")
        subprocess.run([
            str(FFMPEG), "-hide_banner", "-loglevel", "error", "-y",
            "-f", "lavfi", "-i", "anoisesrc=color=brown:amplitude=0.14:sample_rate=44100",
            "-f", "lavfi", "-i", "sine=frequency=528:sample_rate=44100",
            "-f", "lavfi", "-i", "sine=frequency=264:sample_rate=44100",
            "-f", "lavfi", "-i", "sine=frequency=396:sample_rate=44100",
            "-filter_complex",
            "[0:a]lowpass=f=320,volume=0.42[fire];"
            "[1:a]tremolo=f=1.5:d=0.6,volume=0.018[chime];"
            "[2:a]volume=0.022[warm];"
            "[3:a]tremolo=f=0.5:d=0.4,volume=0.014[fifth];"
            "[fire][chime][warm][fifth]amix=inputs=4:normalize=0,"
            "afade=t=in:st=0:d=2,afade=t=out:st=56:d=4",
            "-t", "60", "-c:a", "aac", "-b:a", "96k", str(so21)
        ], check=True)

    # 2. SO-22: 639 Hz Autumn Harvest Warmth
    so22 = MUSIC_DIR / "so-22-autumn-harvest-acoustic.m4a"
    if not so22.exists():
        print("Generating SO-22 (639 Hz Autumn Harvest Warmth)...")
        subprocess.run([
            str(FFMPEG), "-hide_banner", "-loglevel", "error", "-y",
            "-f", "lavfi", "-i", "anoisesrc=color=pink:amplitude=0.09:sample_rate=44100",
            "-f", "lavfi", "-i", "sine=frequency=639:sample_rate=44100",
            "-f", "lavfi", "-i", "sine=frequency=319.5:sample_rate=44100",
            "-f", "lavfi", "-i", "sine=frequency=213:sample_rate=44100",
            "-filter_complex",
            "[0:a]lowpass=f=260,volume=0.34[breeze];"
            "[1:a]tremolo=f=0.8:d=0.5,volume=0.015[hi];"
            "[2:a]volume=0.024[mid];"
            "[3:a]volume=0.018[low];"
            "[breeze][hi][mid][low]amix=inputs=4:normalize=0,"
            "afade=t=in:st=0:d=2,afade=t=out:st=56:d=4",
            "-t", "60", "-c:a", "aac", "-b:a", "96k", str(so22)
        ], check=True)

    # 3. SO-23: 432 Hz Peaceful Tết Morning Melody
    so23 = MUSIC_DIR / "so-23-peaceful-tet-spring-lullaby.m4a"
    if not so23.exists():
        print("Generating SO-23 (432 Hz Peaceful Tết Morning)...")
        subprocess.run([
            str(FFMPEG), "-hide_banner", "-loglevel", "error", "-y",
            "-f", "lavfi", "-i", "anoisesrc=color=pink:amplitude=0.07:sample_rate=44100",
            "-f", "lavfi", "-i", "sine=frequency=432:sample_rate=44100",
            "-f", "lavfi", "-i", "sine=frequency=288:sample_rate=44100",
            "-f", "lavfi", "-i", "sine=frequency=648:sample_rate=44100",
            "-filter_complex",
            "[0:a]lowpass=f=300,volume=0.28[spring];"
            "[1:a]volume=0.022[root];"
            "[2:a]volume=0.018[warm];"
            "[3:a]tremolo=f=2.2:d=0.65,volume=0.012[chime];"
            "[spring][root][warm][chime]amix=inputs=4:normalize=0,"
            "afade=t=in:st=0:d=2,afade=t=out:st=56:d=4",
            "-t", "60", "-c:a", "aac", "-b:a", "96k", str(so23)
        ], check=True)


GUIDED_TRACKS = [
    {
        "id": "GA-32",
        "slug": "mothers-morning-greeting",
        "bed": MUSIC_DIR / "so-23-peaceful-tet-spring-lullaby.m4a",
        "bed_volume": 0.22,
        "vi_paragraphs": [
            "Con dậy chưa? Trời sáng ấm rồi đó con.",
            "Dậy từ từ thôi nhé, không cần phải vội đâu.",
            "Ngoài hiên nắng sớm dịu lắm, chim đang hót ngoài khoảng sân nhỏ, và mẹ vừa pha sẵn bình trà ấm đặt trên bàn rồi.",
            "Con hít một hơi thật sâu nào... cảm nhận hương nắng mới và sự bình yên quen thuộc của nhà mình.",
            "Dù ngoài kia có bận rộn thế nào, ở đây con luôn có một nơi bình yên để thuộc về.",
            "Hôm nay cứ thong thả, dịu dàng và mỉm cười đón ngày mới nhé con."
        ],
        "en_paragraphs": [
            "Are you awake yet, my dear? The morning light is already warm.",
            "Wake up slowly. There is no need to rush today.",
            "Outside on the porch, the morning sun is gentle, birds are singing in the little courtyard, and a warm pot of tea is waiting for you on the table.",
            "Take a deep, gentle breath... feel the fresh morning air and the familiar safety of home.",
            "No matter how busy the world outside may be, you always have a peaceful place here where you belong.",
            "Go gently today, be kind to yourself, and welcome this new beginning with a quiet smile."
        ],
    },
    {
        "id": "GA-33",
        "slug": "gryffindor-winter-sanctuary",
        "bed": MUSIC_DIR / "so-21-gryffindor-hearth-chimes.m4a",
        "bed_volume": 0.22,
        "vi_paragraphs": [
            "Chào mừng bạn trở về căn phòng riêng ấm áp trên đỉnh tháp cổ.",
            "Bên ngoài khung cửa sổ vòm cao, tuyết đêm Giáng Sinh đang rơi thật khẽ, phủ trắng cả bầu trời đêm đông.",
            "Nhưng ở bên trong này, ngọn lửa trong lò sưởi đang cháy bập bùng, tỏa hơi ấm dịu dàng lên chiếc ghế bành bọc nhung đỏ và tấm chăn len dày.",
            "Ánh đèn vàng trên cây thông nhỏ khẽ lấp lánh bên những cuốn sách cổ.",
            "Hãy cuộn mình thật êm, hít vào hơi ấm của căn phòng phép thuật này, và để mọi mệt mỏi tan biến sau cánh cửa gỗ."
        ],
        "en_paragraphs": [
            "Welcome back to your private sanctuary high inside the ancient tower.",
            "Beyond the tall arched window, Christmas snow is falling softly across the winter night.",
            "Inside this room, the hearth fire crackles warmly, casting a golden glow over your velvet armchair and thick wool blanket.",
            "Tiny lights twinkle on the Christmas tree beside stacks of old spellbooks.",
            "Curl up comfortably, breathe in the magical warmth of your sanctuary, and let the outside world fade away."
        ],
    },
    {
        "id": "GA-34",
        "slug": "autumn-thanksgiving-gratitude",
        "bed": MUSIC_DIR / "so-22-autumn-harvest-acoustic.m4a",
        "bed_volume": 0.22,
        "vi_paragraphs": [
            "Trong căn bếp nhỏ chiều thu, ánh nắng màu mật ong đang chiếu qua khung cửa sổ nhìn ra rừng lá đỏ cam.",
            "Trên bàn gỗ, chiếc bánh nướng vừa ra lò tỏa hương quế ấm áp bên tách trà nóng và ánh nến dịu dàng.",
            "Hãy hít một hơi thật chậm, cảm nhận sự đủ đầy, ấm cúng đang bao quanh bạn ngay lúc này.",
            "Biết ơn những mùa đã đi qua, biết ơn những người thương yêu, và biết ơn chính bạn vì đã kiên trì đi đến hôm nay."
        ],
        "en_paragraphs": [
            "In this cozy autumn kitchen, honey-gold afternoon light streams through the window overlooking a forest of red and amber leaves.",
            "On the wooden table, a freshly baked pie shares its warm cinnamon aroma beside a steaming cup of tea and soft candlelight.",
            "Take a slow, deep breath and feel the quiet abundance surrounding you right now.",
            "Be grateful for the seasons you have walked through, the warmth of home, and yourself for coming this far."
        ],
    },
]


async def render_single_paragraph(text, voice, rate, pitch, out_path, retries=4):
    for attempt in range(retries):
        try:
            comm = edge_tts.Communicate(
                text,
                voice,
                rate=rate,
                pitch=pitch,
                connect_timeout=20,
                receive_timeout=30,
            )
            await asyncio.wait_for(comm.save(str(out_path)), timeout=40.0)
            if out_path.exists() and out_path.stat().st_size > 0:
                return
        except Exception:
            if attempt == retries - 1:
                raise
            await asyncio.sleep(1.5 * (attempt + 1))


async def render_tts_track(paragraphs, voice, rate, pitch, pause_sec, temp_prefix):
    temp_files = []
    wav_segments = []
    try:
        for idx, text in enumerate(paragraphs):
            mp3_seg = Path(f"{temp_prefix}_seg_{idx}.mp3")
            wav_seg = Path(f"{temp_prefix}_seg_{idx}.wav")
            await render_single_paragraph(text, voice, rate, pitch, mp3_seg)
            temp_files.append(mp3_seg)
            subprocess.run([
                str(FFMPEG), "-hide_banner", "-loglevel", "error", "-y",
                "-i", str(mp3_seg),
                "-af", "afade=t=in:ss=0:d=0.015,areverse,afade=t=in:ss=0:d=0.015,areverse",
                "-ar", "44100", "-ac", "2", "-c:a", "pcm_s16le",
                str(wav_seg)
            ], check=True)
            wav_segments.append(wav_seg)
            temp_files.append(wav_seg)

        silence_file = Path(f"{temp_prefix}_silence.wav")
        temp_files.append(silence_file)
        subprocess.run([
            str(FFMPEG), "-hide_banner", "-loglevel", "error", "-y",
            "-f", "lavfi", "-i", "anullsrc=r=44100:cl=stereo",
            "-t", str(pause_sec), "-c:a", "pcm_s16le",
            str(silence_file)
        ], check=True)

        concat_list = Path(f"{temp_prefix}_list.txt")
        temp_files.append(concat_list)
        with open(concat_list, "w", encoding="utf-8") as f:
            for idx, sf in enumerate(wav_segments):
                f.write(f"file '{sf.resolve().as_posix()}'\n")
                if idx < len(wav_segments) - 1:
                    f.write(f"file '{silence_file.resolve().as_posix()}'\n")

        full_voice = Path(f"{temp_prefix}_voice_full.wav")
        subprocess.run([
            str(FFMPEG), "-hide_banner", "-loglevel", "error", "-y",
            "-f", "concat", "-safe", "0", "-i", str(concat_list),
            "-c:a", "pcm_s16le", str(full_voice)
        ], check=True)
        return full_voice
    finally:
        for sf in temp_files:
            if sf.exists():
                try:
                    sf.unlink()
                except Exception:
                    pass


def mix_voice_and_bed(voice_file, bed_file, bed_vol, output_file):
    subprocess.run([
        str(FFMPEG), "-hide_banner", "-loglevel", "error", "-y",
        "-i", str(voice_file),
        "-stream_loop", "-1", "-i", str(bed_file),
        "-filter_complex",
        f"[0:a]volume=1.0[v];[1:a]volume={bed_vol:.2f}[b];"
        "[v][b]amix=inputs=2:duration=first:dropout_transition=2,"
        "alimiter=limit=0.92:attack=5:release=50[outa]",
        "-map", "[outa]", "-vn", "-c:a", "aac", "-b:a", "96k", "-ar", "44100",
        str(output_file)
    ], check=True)
    if voice_file.exists():
        try:
            voice_file.unlink()
        except Exception:
            pass


async def main():
    generate_music_beds()
    vi_dir = GUIDED_DIR / "vi"
    en_dir = GUIDED_DIR / "en"
    vi_dir.mkdir(parents=True, exist_ok=True)
    en_dir.mkdir(parents=True, exist_ok=True)

    for t in GUIDED_TRACKS:
        code = t["id"].lower()
        slug = t["slug"]
        vi_out = vi_dir / f"{code}-{slug}.m4a"
        if not vi_out.exists():
            print(f"Rendering VI guided track: {vi_out.name}...")
            v_vi = await render_tts_track(
                t["vi_paragraphs"],
                voice="fr-FR-VivienneMultilingualNeural",
                rate="-10%",
                pitch="+0Hz",
                pause_sec=2.0,
                temp_prefix=f"tmp_vi_{code}"
            )
            mix_voice_and_bed(v_vi, t["bed"], t["bed_volume"], vi_out)

        en_out = en_dir / f"{code}-{slug}.m4a"
        if not en_out.exists():
            print(f"Rendering EN guided track: {en_out.name}...")
            v_en = await render_tts_track(
                t["en_paragraphs"],
                voice="en-US-AvaNeural",
                rate="-15%",
                pitch="-2Hz",
                pause_sec=2.0,
                temp_prefix=f"tmp_en_{code}"
            )
            mix_voice_and_bed(v_en, t["bed"], t["bed_volume"], en_out)

    print("All new Comfort Zone audio assets generated successfully!")


if __name__ == "__main__":
    asyncio.run(main())
