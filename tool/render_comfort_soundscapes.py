"""
Generate custom, high-fidelity ambient soundscapes for Comfort Zone (Góc nhỏ):
- SO-24: Sóng biển rì rào & Gió lộng (Ocean Wind & Rolling Waves - 285 Hz)
- SO-25: Mèo rừ rừ & Piano ấm áp (Cat Purring & Gentle Felt Piano - 432 Hz)
- SO-26: Bạn cún & Nhịp điệu acoustic ấm áp (Playful Puppy & Warm Acoustic)
- SO-27: Tiếng chim hót & Gió thông rừng sâu (Forest Birds & Whispering Breeze - 528 Hz)
- SO-28: Bếp ấm & Tiếng nước sôi liu riu (Cozy Kitchen Simmer & Kettle Steam)
"""

import subprocess
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
FFMPEG = Path("ffmpeg")
AMBIENCE_DIR = BASE_DIR / "assets" / "audio" / "ambience"


def generate_soundscapes():
    AMBIENCE_DIR.mkdir(parents=True, exist_ok=True)

    # 1. SO-24: Ocean Wind & Rolling Waves (285 Hz)
    # Uses modulated brown noise for rolling ocean breakers, gentle pink noise for coastal wind,
    # and a warm 285 Hz restorative tone.
    so24 = AMBIENCE_DIR / "so-24-ocean-wind-waves.m4a"
    print("Generating SO-24: Ocean Wind & Rolling Waves...")
    subprocess.run([
        str(FFMPEG), "-hide_banner", "-loglevel", "error", "-y",
        "-f", "lavfi", "-i", "anoisesrc=color=brown:amplitude=0.35:sample_rate=44100",
        "-f", "lavfi", "-i", "anoisesrc=color=pink:amplitude=0.18:sample_rate=44100",
        "-f", "lavfi", "-i", "sine=frequency=285:sample_rate=44100",
        "-f", "lavfi", "-i", "sine=frequency=142.5:sample_rate=44100",
        "-filter_complex",
        # Rolling surf wave modulation: 0.12 Hz cycle
        "[0:a]lowpass=f=450,tremolo=f=0.12:d=0.85,volume=0.55[surf];"
        # Coastal ocean wind: filtered pink noise with gentle swelling
        "[1:a]bandpass=f=380:width_type=h:w=260,tremolo=f=0.12:d=0.45,volume=0.28[wind];"
        # Calming 285 Hz frequency bed
        "[2:a]volume=0.012[f285];"
        "[3:a]volume=0.015[fsub];"
        "[surf][wind][f285][fsub]amix=inputs=4:normalize=0,"
        "afade=t=in:st=0:d=2.5,afade=t=out:st=57:d=3.0",
        "-t", "60", "-c:a", "aac", "-b:a", "128k", str(so24)
    ], check=True)

    # 2. SO-25: Cat Purring & Gentle Felt Piano (432 Hz)
    # Generates a soothing low-frequency cat purr oscillation (~25 Hz vibrato)
    # blended with a gentle 432 Hz warm piano chord progression bed.
    so25 = AMBIENCE_DIR / "so-25-purring-cat-piano.m4a"
    print("Generating SO-25: Cat Purring & Felt Piano...")
    subprocess.run([
        str(FFMPEG), "-hide_banner", "-loglevel", "error", "-y",
        "-f", "lavfi", "-i", "anoisesrc=color=brown:amplitude=0.22:sample_rate=44100",
        "-f", "lavfi", "-i", "sine=frequency=25:sample_rate=44100",
        "-f", "lavfi", "-i", "sine=frequency=432:sample_rate=44100",
        "-f", "lavfi", "-i", "sine=frequency=288:sample_rate=44100",
        "-f", "lavfi", "-i", "sine=frequency=324:sample_rate=44100",
        "-filter_complex",
        # Cat purr: brown noise lowpassed at 180Hz, modulated by rapid 24Hz purr vibrato & 0.25Hz breathing
        "[0:a]lowpass=f=180,tremolo=f=24:d=0.75,tremolo=f=0.28:d=0.35,volume=0.52[purr_noise];"
        "[1:a]lowpass=f=80,tremolo=f=24:d=0.6,volume=0.08[purr_sub];"
        # Warm relaxing piano chords (A4=432Hz harmonic bed)
        "[2:a]tremolo=f=0.5:d=0.3,volume=0.020[piano1];"
        "[3:a]volume=0.022[piano2];"
        "[4:a]tremolo=f=1.2:d=0.4,volume=0.016[piano3];"
        "[purr_noise][purr_sub][piano1][piano2][piano3]amix=inputs=5:normalize=0,"
        "afade=t=in:st=0:d=2.0,afade=t=out:st=57:d=3.0",
        "-t", "60", "-c:a", "aac", "-b:a", "128k", str(so25)
    ], check=True)

    # 3. SO-26: Playful Puppy & Warm Acoustic Melody
    # Playful, uplifting warm acoustic rhythm bed with gentle breathing warmth and acoustic chimes.
    so26 = AMBIENCE_DIR / "so-26-playful-puppy-acoustic.m4a"
    print("Generating SO-26: Playful Puppy & Acoustic Melody...")
    subprocess.run([
        str(FFMPEG), "-hide_banner", "-loglevel", "error", "-y",
        "-f", "lavfi", "-i", "anoisesrc=color=pink:amplitude=0.10:sample_rate=44100",
        "-f", "lavfi", "-i", "sine=frequency=528:sample_rate=44100",
        "-f", "lavfi", "-i", "sine=frequency=396:sample_rate=44100",
        "-f", "lavfi", "-i", "sine=frequency=660:sample_rate=44100",
        "-f", "lavfi", "-i", "sine=frequency=792:sample_rate=44100",
        "-filter_complex",
        # Cozy warm room background
        "[0:a]lowpass=f=280,volume=0.22[room];"
        # Gentle rhythmic plucked chimes / acoustic harmonics
        "[1:a]tremolo=f=2.0:d=0.7,volume=0.018[note1];"
        "[2:a]volume=0.022[root];"
        "[3:a]tremolo=f=3.0:d=0.6,volume=0.014[note2];"
        "[4:a]tremolo=f=1.5:d=0.5,volume=0.012[note3];"
        "[room][note1][root][note2][note3]amix=inputs=5:normalize=0,"
        "afade=t=in:st=0:d=2.0,afade=t=out:st=57:d=3.0",
        "-t", "60", "-c:a", "aac", "-b:a", "128k", str(so26)
    ], check=True)

    # 4. SO-27: Forest Birds & Whispering Breeze (528 Hz)
    # Whisper of wind through tall pines combined with delicate chirping birdsong harmonics
    # and a 528 Hz healing love frequency.
    so27 = AMBIENCE_DIR / "so-27-forest-birds-gentle-breeze.m4a"
    print("Generating SO-27: Forest Birds & Whispering Breeze...")
    subprocess.run([
        str(FFMPEG), "-hide_banner", "-loglevel", "error", "-y",
        "-f", "lavfi", "-i", "anoisesrc=color=pink:amplitude=0.16:sample_rate=44100",
        "-f", "lavfi", "-i", "anoisesrc=color=brown:amplitude=0.14:sample_rate=44100",
        "-f", "lavfi", "-i", "sine=frequency=528:sample_rate=44100",
        "-f", "lavfi", "-i", "sine=frequency=2640:sample_rate=44100",
        "-f", "lavfi", "-i", "sine=frequency=3168:sample_rate=44100",
        "-filter_complex",
        # Forest canopy wind: gentle swaying lowpass filter
        "[0:a]bandpass=f=420:width_type=h:w=280,tremolo=f=0.15:d=0.5,volume=0.32[canopy_wind];"
        "[1:a]lowpass=f=220,volume=0.25[earth];"
        # 528 Hz healing tone
        "[2:a]volume=0.015[tone528];"
        # Birdsong chirps: modulated high frequencies creating realistic bird flutter
        "[3:a]tremolo=f=5.5:d=0.85,volume=0.008[bird1];"
        "[4:a]tremolo=f=7.2:d=0.80,volume=0.006[bird2];"
        "[canopy_wind][earth][tone528][bird1][bird2]amix=inputs=5:normalize=0,"
        "afade=t=in:st=0:d=2.0,afade=t=out:st=57:d=3.0",
        "-t", "60", "-c:a", "aac", "-b:a", "128k", str(so27)
    ], check=True)

    # 5. SO-28: Cozy Kitchen Simmer & Kettle Steam
    # Warm gentle bubbling water, kettle steam whisper, and acoustic comfort.
    so28 = AMBIENCE_DIR / "so-28-cozy-kitchen-simmer.m4a"
    print("Generating SO-28: Cozy Kitchen Simmer & Kettle Steam...")
    subprocess.run([
        str(FFMPEG), "-hide_banner", "-loglevel", "error", "-y",
        "-f", "lavfi", "-i", "anoisesrc=color=brown:amplitude=0.25:sample_rate=44100",
        "-f", "lavfi", "-i", "anoisesrc=color=pink:amplitude=0.12:sample_rate=44100",
        "-f", "lavfi", "-i", "sine=frequency=396:sample_rate=44100",
        "-f", "lavfi", "-i", "sine=frequency=594:sample_rate=44100",
        "-filter_complex",
        # Simmering water bubbles: brown noise with fast random-like tremolo
        "[0:a]bandpass=f=350:width_type=h:w=180,tremolo=f=8.0:d=0.65,volume=0.38[bubbles];"
        # Steam hiss: gentle high-frequency whisper
        "[1:a]bandpass=f=2200:width_type=h:w=1200,tremolo=f=0.2:d=0.35,volume=0.08[steam];"
        # Cozy warm kitchen harmonic tones
        "[2:a]volume=0.020[warmth];"
        "[3:a]tremolo=f=1.0:d=0.4,volume=0.012[melody];"
        "[bubbles][steam][warmth][melody]amix=inputs=4:normalize=0,"
        "afade=t=in:st=0:d=2.0,afade=t=out:st=57:d=3.0",
        "-t", "60", "-c:a", "aac", "-b:a", "128k", str(so28)
    ], check=True)

    print("All 5 soundscapes rendered successfully!")


if __name__ == "__main__":
    generate_soundscapes()
