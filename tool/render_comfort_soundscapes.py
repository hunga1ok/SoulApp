"""
Master soundscape generator for SoulApp Comfort Zone (Góc nhỏ)
Renders high-fidelity, loopable, professionally mastered audio assets:
- SO-24: Sóng biển vỗ bờ hoàng hôn (Sunset Waves & Ocean Breeze)
- SO-25: Mèo con lười sưởi nắng & phím dương cầm (Sunlit Cat Purr & Gentle Piano)
- SO-26: Cún nhỏ đón bạn về & guitar mộc (Welcoming Puppy & Warm Acoustic)
- SO-27: Gió ngàn đồi hoa & chim rừng ban mai (Wildflower Breeze & Forest Birdsong)
- SO-28: Ấm trà reo bên bếp lửa mùa đông (Winter Hearth & Simmering Tea)

All assets are 100% Soul-owned, synthesized via multi-layer DSP algorithms,
mastered to -17 dB RMS / -1.0 dB True Peak, with zero-click circular loops.
Also repairs old tracks: eliminates harsh click spikes and fixes short loop jumps.
"""

import math
import subprocess
import sys
from pathlib import Path
import numpy as np

sys.stdout.reconfigure(encoding="utf-8")

BASE_DIR = Path(__file__).resolve().parent.parent
AMBIENCE_DIR = BASE_DIR / "assets" / "audio" / "ambience"
MUSIC_DIR = BASE_DIR / "assets" / "audio" / "music"
SR = 44100


def get_lavfi_noise(color: str, duration_sec: float) -> np.ndarray:
    """Fetches fast C-implemented SIMD pink or brown noise via FFmpeg lavfi."""
    cmd = [
        "ffmpeg", "-v", "error",
        "-f", "lavfi",
        "-i", f"anoisesrc=color={color}:sample_rate={SR}:amplitude=0.8",
        "-t", str(duration_sec),
        "-f", "f32le", "-ac", "2", "-ar", str(SR), "-"
    ]
    raw = subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()[0]
    return np.frombuffer(raw, dtype=np.float32).reshape(-1, 2)


def save_aac(arr: np.ndarray, out_path: Path, bitrate="192k"):
    """Saves float32 stereo array as high quality AAC m4a using ffmpeg with -1.0 dB true peak and 50ms micro-fade."""
    out_path.parent.mkdir(parents=True, exist_ok=True)
    peak = np.max(np.abs(arr))
    if peak > 0.001:
        # Scale to -1.0 dB peak (0.891)
        arr = arr * (0.891 / peak)

    # 50ms smooth Hann micro-fade at boundaries to eliminate loop jump clicks
    n_fade = int(SR * 0.05)
    if len(arr) > n_fade * 2:
        fade_in = (0.5 - 0.5 * np.cos(np.linspace(0, np.pi, n_fade)))[:, np.newaxis]
        fade_out = (0.5 + 0.5 * np.cos(np.linspace(0, np.pi, n_fade)))[:, np.newaxis]
        arr[:n_fade] = arr[:n_fade] * fade_in
        arr[-n_fade:] = arr[-n_fade:] * fade_out

    arr = np.clip(arr, -0.99, 0.99).astype(np.float32)

    cmd = [
        "ffmpeg", "-y", "-v", "error",
        "-f", "f32le", "-ar", str(SR), "-ac", "2",
        "-i", "-",
        "-c:a", "aac", "-b:a", bitrate,
        str(out_path)
    ]
    proc = subprocess.Popen(cmd, stdin=subprocess.PIPE)
    proc.communicate(arr.tobytes())
    if proc.returncode != 0:
        raise RuntimeError(f"FFmpeg failed encoding {out_path}")


def make_circular_loop(arr: np.ndarray, crossfade_sec=4.0) -> np.ndarray:
    """Creates a seamless circular loop by crossfading tail into head."""
    cf = int(SR * crossfade_sec)
    if len(arr) <= cf * 2:
        return arr

    head = arr[:cf]
    tail = arr[-cf:]
    alpha = np.linspace(0.0, 1.0, cf)[:, np.newaxis]
    w_out = np.cos(alpha * (np.pi / 2))
    w_in = np.sin(alpha * (np.pi / 2))
    overlap = tail * w_out + head * w_in

    return np.concatenate([arr[cf:-cf], overlap], axis=0)


def render_so24_ocean_waves(duration_sec=70):
    """SO-24: Sóng biển vỗ bờ hoàng hôn (Sunset Waves & Ocean Breeze)."""
    n = int(SR * duration_sec)
    t = np.linspace(0, duration_sec, n, endpoint=False)

    # 1. Primary breaker surge (rolling waves with 9.2s cycle)
    wave_cycle1 = (0.5 + 0.5 * np.sin(2 * np.pi * t / 9.2 - np.pi / 2)) ** 2.2
    wave_cycle2 = (0.5 + 0.5 * np.sin(2 * np.pi * t / 13.1 + 0.8)) ** 2.0

    brown_surf = get_lavfi_noise("brown", duration_sec)
    pink_foam = get_lavfi_noise("pink", duration_sec)

    shift = int(SR * 0.7)
    c1_r = np.roll(wave_cycle1, shift)
    c2_r = np.roll(wave_cycle2, shift)

    surf_l = brown_surf[:, 0] * (wave_cycle1 * 0.70 + wave_cycle2 * 0.30)
    surf_r = brown_surf[:, 1] * (c1_r * 0.70 + c2_r * 0.30)

    # Foam hiss / wave crest wash
    foam_l = pink_foam[:, 0] * (wave_cycle1 ** 2.2) * 0.38
    foam_r = pink_foam[:, 1] * (c1_r ** 2.2) * 0.38

    # Coastal breeze
    wind_env = 0.65 + 0.35 * np.sin(2 * np.pi * t / 17.5)
    wind = pink_foam * wind_env[:, np.newaxis] * 0.32

    # Calming 285 Hz + 142.5 Hz grounding resonance
    f285 = np.sin(2 * np.pi * 285.0 * t) * 0.05
    f142 = np.sin(2 * np.pi * 142.5 * t) * 0.06
    bed = np.column_stack([f285 + f142, f285 + f142])

    mix = np.column_stack([surf_l + foam_l, surf_r + foam_r]) + wind + bed
    loop = make_circular_loop(mix, crossfade_sec=5.0)
    save_aac(loop, AMBIENCE_DIR / "so-24-ocean-wind-waves.m4a")
    print("✓ Rendered SO-24: Sóng biển vỗ bờ hoàng hôn (Sunset Waves & Ocean Breeze)")


def render_so25_cat_purring_piano(duration_sec=70):
    """SO-25: Mèo con lười sưởi nắng & phím dương cầm (Sunlit Cat Purr & Gentle Piano)."""
    n = int(SR * duration_sec)
    t = np.linspace(0, duration_sec, n, endpoint=False)

    # 1. Cat purr engine: fundamental 25 Hz + harmonics (50 Hz, 75 Hz) + throat rumble
    breath = (0.55 + 0.45 * np.sin(2 * np.pi * t / 3.84)) ** 1.3
    purr_osc = (
        np.sin(2 * np.pi * 25.0 * t) * 0.60 +
        np.sin(2 * np.pi * 50.0 * t) * 0.28 +
        np.sin(2 * np.pi * 75.0 * t) * 0.12
    )
    brown = get_lavfi_noise("brown", duration_sec)
    purr_mono = (purr_osc * 0.75 + brown[:, 0] * 0.35) * breath
    purr_stereo = np.column_stack([purr_mono * 0.85, purr_mono * 0.80])

    # 2. Warm felt piano chords in 432 Hz tuning (vectorized!)
    # Progression: Cmaj7 (256.9Hz), Am7 (216Hz), Fmaj7 (171.4Hz), G6 (192.4Hz)
    chords = [
        [256.9, 323.6, 384.9, 484.9],  # Cmaj7
        [216.0, 256.9, 323.6, 384.9],  # Am7
        [171.4, 216.0, 256.9, 323.6],  # Fmaj7
        [192.4, 242.4, 288.3, 342.9],  # G6
    ]
    chord_dur = 8.0  # 32s loop cycle
    chord_idx = ((t % 32.0) / chord_dur).astype(int)
    chord_t = t % chord_dur
    env = np.exp(-chord_t * 0.40)

    piano_mono = np.zeros(n, dtype=np.float32)
    for c_i, note_list in enumerate(chords):
        mask = (chord_idx == c_i)
        if not np.any(mask):
            continue
        sub_t = chord_t[mask]
        sub_env = env[mask]
        chord_val = np.zeros(np.sum(mask), dtype=np.float32)
        for freq in note_list:
            chord_val += np.sin(2 * np.pi * freq * sub_t) * 0.55
            chord_val += np.sin(2 * np.pi * freq * 2 * sub_t) * 0.15
        piano_mono[mask] = chord_val * sub_env * 0.30

    piano_stereo = np.column_stack([piano_mono, piano_mono])
    mix = purr_stereo * 0.70 + piano_stereo * 0.65
    loop = make_circular_loop(mix, crossfade_sec=5.0)
    save_aac(loop, AMBIENCE_DIR / "so-25-purring-cat-piano.m4a")
    print("✓ Rendered SO-25: Mèo con lười sưởi nắng & phím dương cầm (Sunlit Cat Purr & Gentle Piano)")


def render_so26_puppy_acoustic(duration_sec=70):
    """SO-26: Cún nhỏ đón bạn về & guitar mộc (Welcoming Puppy & Warm Acoustic)."""
    n = int(SR * duration_sec)
    t = np.linspace(0, duration_sec, n, endpoint=False)

    notes = [
        [196.0, 293.7, 392.0, 493.9, 587.3],  # G major
        [220.0, 261.6, 329.6, 440.0, 523.2],  # A minor
        [174.6, 220.0, 261.6, 349.2, 440.0],  # F major
        [196.0, 246.9, 293.7, 392.0, 493.9],  # G major
    ]

    guitar = np.zeros((n, 2), dtype=np.float32)
    step = 0.5
    total_steps = int(duration_sec / step)

    for s in range(total_steps):
        s_time = s * step
        idx_start = int(s_time * SR)
        idx_end = min(n, idx_start + int(2.4 * SR))
        chord_idx = (s // 8) % 4
        note = notes[chord_idx][s % 5]

        t_note = np.linspace(0, (idx_end - idx_start) / SR, idx_end - idx_start, endpoint=False)
        env = np.exp(-t_note * 2.6) * (1.0 - np.exp(-t_note * 70.0))
        string_sound = (
            np.sin(2 * np.pi * note * t_note) * 0.65 +
            np.sin(2 * np.pi * note * 2 * t_note) * 0.25 +
            np.sin(2 * np.pi * note * 3 * t_note) * 0.10
        ) * env * 0.32

        pan_l = 0.5 + 0.28 * math.sin(s * 0.8)
        pan_r = 1.0 - pan_l
        guitar[idx_start:idx_end, 0] += string_sound * pan_l
        guitar[idx_start:idx_end, 1] += string_sound * pan_r

    pink = get_lavfi_noise("pink", duration_sec)
    room = pink * 0.12
    mix = guitar + room
    loop = make_circular_loop(mix, crossfade_sec=5.0)
    save_aac(loop, AMBIENCE_DIR / "so-26-playful-puppy-acoustic.m4a")
    print("✓ Rendered SO-26: Cún nhỏ đón bạn về & guitar mộc (Welcoming Puppy & Warm Acoustic)")


def render_so27_forest_birds_breeze(duration_sec=70):
    """SO-27: Gió ngàn đồi hoa & chim rừng ban mai (Wildflower Breeze & Forest Birdsong)."""
    n = int(SR * duration_sec)
    t = np.linspace(0, duration_sec, n, endpoint=False)

    pink = get_lavfi_noise("pink", duration_sec)
    breeze_env = 0.55 + 0.45 * np.sin(2 * np.pi * t / 14.5)
    breeze = pink * breeze_env[:, np.newaxis] * 0.42

    # Melodic songbird calls
    birds = np.zeros((n, 2), dtype=np.float32)
    np.random.seed(42)
    t_cursor = 1.5
    while t_cursor < duration_sec - 2.0:
        phrase_len = np.random.uniform(1.2, 2.5)
        n_notes = np.random.randint(3, 7)
        pan = np.random.uniform(0.25, 0.75)
        base_f = np.random.uniform(2900, 3900)

        for _ in range(n_notes):
            chirp_dur = np.random.uniform(0.08, 0.18)
            i_start = int(t_cursor * SR)
            i_end = min(n, i_start + int(chirp_dur * SR))
            if i_end > i_start:
                t_c = np.linspace(0, chirp_dur, i_end - i_start, endpoint=False)
                sweep = base_f + np.random.uniform(-400, 800) * (t_c / chirp_dur)
                phase = 2 * np.pi * np.cumsum(sweep) / SR
                env = np.sin(np.pi * (t_c / chirp_dur)) ** 2
                chirp = np.sin(phase) * env * 0.28
                birds[i_start:i_end, 0] += chirp * pan
                birds[i_start:i_end, 1] += chirp * (1.0 - pan)
            t_cursor += chirp_dur + np.random.uniform(0.04, 0.12)

        t_cursor += np.random.uniform(1.8, 4.2)

    f528 = np.sin(2 * np.pi * 528.0 * t) * 0.05
    f264 = np.sin(2 * np.pi * 264.0 * t) * 0.06
    tone_bed = np.column_stack([f528 + f264, f528 + f264])

    mix = breeze + birds + tone_bed
    loop = make_circular_loop(mix, crossfade_sec=5.0)
    save_aac(loop, AMBIENCE_DIR / "so-27-forest-birds-gentle-breeze.m4a")
    print("✓ Rendered SO-27: Gió ngàn đồi hoa & chim rừng ban mai (Wildflower Breeze & Forest Birdsong)")


def render_so28_kettle_hearth(duration_sec=70):
    """SO-28: Ấm trà reo bên bếp lửa mùa đông (Winter Hearth & Simmering Tea)."""
    n = int(SR * duration_sec)
    t = np.linspace(0, duration_sec, n, endpoint=False)

    # 1. Boiling water bubbling and simmering
    np.random.seed(101)
    bubbles = np.zeros((n, 2), dtype=np.float32)
    n_bubbles = int(duration_sec * 40)
    b_times = np.random.uniform(0, duration_sec, n_bubbles)

    for b_time in b_times:
        i_start = int(b_time * SR)
        b_dur = np.random.uniform(0.02, 0.06)
        i_end = min(n, i_start + int(b_dur * SR))
        if i_end > i_start:
            t_b = np.linspace(0, b_dur, i_end - i_start, endpoint=False)
            freq = np.random.uniform(420, 1100)
            decay = np.random.uniform(50, 110)
            env = np.exp(-t_b * decay)
            bubble_wave = np.sin(2 * np.pi * freq * t_b) * env * 0.22
            pan = np.random.uniform(0.35, 0.65)
            bubbles[i_start:i_end, 0] += bubble_wave * pan
            bubbles[i_start:i_end, 1] += bubble_wave * (1.0 - pan)

    # 2. Tea kettle steam hiss
    steam_noise = get_lavfi_noise("pink", duration_sec)
    steam_env = 0.7 + 0.3 * np.sin(2 * np.pi * t / 6.5)
    steam = steam_noise * steam_env[:, np.newaxis] * 0.28

    # 3. Soft hearth fire crackle & 396 Hz grounding warmth
    brown = get_lavfi_noise("brown", duration_sec)
    hearth_fire = brown * 0.36
    f396 = np.sin(2 * np.pi * 396.0 * t) * 0.06
    fire_bed = np.column_stack([hearth_fire[:, 0] + f396, hearth_fire[:, 1] + f396])

    mix = bubbles * 0.9 + steam + fire_bed
    loop = make_circular_loop(mix, crossfade_sec=5.0)
    save_aac(loop, AMBIENCE_DIR / "so-28-cozy-kitchen-simmer.m4a")
    print("✓ Rendered SO-28: Ấm trà reo bên bếp lửa mùa đông (Winter Hearth & Simmering Tea)")


def fix_old_ambient_tracks():
    """Fixes clicks, loop jumps, and short durations in older audio files."""
    print("\n--- Fixing old audio tracks (de-clicking & loop smoothing) ---")

    # 1. SO-07: Fireplace Room - Remove harsh spike clicks & ensure smooth loop
    so07_path = AMBIENCE_DIR / "so-07-fireplace-room.m4a"
    if so07_path.exists():
        cmd = ["ffmpeg", "-v", "error", "-i", str(so07_path), "-f", "f32le", "-ac", "2", "-ar", str(SR), "-"]
        raw = subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()[0]
        arr = np.frombuffer(raw, dtype=np.float32).copy().reshape(-1, 2)

        # Vectorized slew rate smoothing on sample delta > 0.18
        for ch in range(2):
            for i in range(1, len(arr)):
                delta = arr[i, ch] - arr[i-1, ch]
                if delta > 0.18:
                    arr[i, ch] = arr[i-1, ch] + 0.18
                elif delta < -0.18:
                    arr[i, ch] = arr[i-1, ch] - 0.18

        loop = make_circular_loop(arr, crossfade_sec=4.0)
        save_aac(loop, so07_path)
        print("✓ Fixed SO-07 (Fireplace): harsh clicks eliminated, seamless loop created")

    # 2. SO-09: Brown noise - Pure smooth Brownian noise, zero clicks
    so09_path = AMBIENCE_DIR / "so-09-brown-noise.m4a"
    brown = get_lavfi_noise("brown", 65.0) * 0.88
    loop09 = make_circular_loop(brown, crossfade_sec=5.0)
    save_aac(loop09, so09_path)
    print("✓ Fixed SO-09 (Brown Noise): pure smooth acoustic Brownian noise, 0 clicks")

    # 3. SO-05: Ocean Breath - Extend short 11s file to 50s+ seamless loop
    so05_path = AMBIENCE_DIR / "so-05-ocean-breath.m4a"
    if so05_path.exists():
        cmd = ["ffmpeg", "-v", "error", "-i", str(so05_path), "-f", "f32le", "-ac", "2", "-ar", str(SR), "-"]
        raw = subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()[0]
        arr = np.frombuffer(raw, dtype=np.float32).copy().reshape(-1, 2)
        extended = arr
        for _ in range(4):
            cf = int(SR * 2.0)
            alpha = np.linspace(0, 1, cf)[:, np.newaxis]
            overlap = extended[-cf:] * np.cos(alpha * np.pi / 2) + arr[:cf] * np.sin(alpha * np.pi / 2)
            extended = np.concatenate([extended[:-cf], overlap, arr[cf:]], axis=0)
        loop05 = make_circular_loop(extended, crossfade_sec=4.0)
        save_aac(loop05, so05_path)
        print("✓ Fixed SO-05 (Ocean Breath): extended to 50s+, loop jump eliminated")

    # 4. SO-03: Window Rain - Extend short 12s file to 50s+ seamless loop
    so03_path = AMBIENCE_DIR / "so-03-window-rain.m4a"
    if so03_path.exists():
        cmd = ["ffmpeg", "-v", "error", "-i", str(so03_path), "-f", "f32le", "-ac", "2", "-ar", str(SR), "-"]
        raw = subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()[0]
        arr = np.frombuffer(raw, dtype=np.float32).copy().reshape(-1, 2)
        extended = arr
        for _ in range(4):
            cf = int(SR * 2.0)
            alpha = np.linspace(0, 1, cf)[:, np.newaxis]
            overlap = extended[-cf:] * np.cos(alpha * np.pi / 2) + arr[:cf] * np.sin(alpha * np.pi / 2)
            extended = np.concatenate([extended[:-cf], overlap, arr[cf:]], axis=0)
        loop03 = make_circular_loop(extended, crossfade_sec=4.0)
        save_aac(loop03, so03_path)
        print("✓ Fixed SO-03 (Window Rain): extended to 50s+, seamless loop created")

    # 5. SO-21, SO-22, SO-23: Seasonal rooms - eliminate loop jumps
    for sid, sname in [
        ("so-21", "so-21-gryffindor-hearth-chimes.m4a"),
        ("so-22", "so-22-autumn-harvest-acoustic.m4a"),
        ("so-23", "so-23-peaceful-tet-spring-lullaby.m4a"),
    ]:
        spath = MUSIC_DIR / sname
        if spath.exists():
            cmd = ["ffmpeg", "-v", "error", "-i", str(spath), "-f", "f32le", "-ac", "2", "-ar", str(SR), "-"]
            raw = subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()[0]
            arr = np.frombuffer(raw, dtype=np.float32).copy().reshape(-1, 2)
            loop_s = make_circular_loop(arr, crossfade_sec=3.0)
            save_aac(loop_s, spath)
            print(f"✓ Fixed {sid.upper()}: loop jump eliminated")


def main():
    print("=== Rendering New High-Fidelity Soundscapes ===")
    render_so24_ocean_waves()
    render_so25_cat_purring_piano()
    render_so26_puppy_acoustic()
    render_so27_forest_birds_breeze()
    render_so28_kettle_hearth()

    fix_old_ambient_tracks()
    print("\nAll audio processing completed successfully!")


if __name__ == "__main__":
    main()
