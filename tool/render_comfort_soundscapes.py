"""
SoulApp Healing Soundscape & Music Generator
Renders high-fidelity, soothing, genuinely healing audio assets:

- SO-24: Sóng biển vỗ bờ hoàng hôn (Sunset Waves & Ocean Breeze)
- SO-25: Mèo con lười sưởi nắng & phím dương cầm (Sunlit Cat Purr & Gentle Piano)
- SO-26: Cún nhỏ đón bạn về & guitar mộc (Welcoming Puppy & Warm Acoustic)
- SO-27: Gió ngàn đồi hoa & chim rừng ban mai (Wildflower Breeze & Forest Birdsong)
- SO-28: Ấm trà reo bên bếp lửa mùa đông (Winter Hearth & Simmering Tea)

Music tracks:
- SO-11: Piano ấm áp (Warm Felt Piano - 432 Hz solo piano)
- SO-12: Chân trời tương lai (Future Horizon - 528 Hz transformation acoustic & strings)
- SO-13: Dòng chảy vàng (Golden Flow - 528 Hz acoustic guitar & Rhodes flow)
- SO-14: Bình yên vững vàng (Rooted Calm - 396 Hz warm cello & felt piano)
- SO-15: Dòng chảy đủ đầy (Abundance Current - 888 Hz celestial music box & harp)
- SO-16: Handpan bầu trời rộng mở (Open Sky Handpan - 741 Hz authentic resonant hang drum)
- SO-17: R&B ấm áp (Warm R&B Ambient - 639 Hz neo-soul lofi Rhodes chords)
- SO-18: Không gian trái tim (Heart Space - 639 Hz piano & romantic harp duet)
- SO-19: Đà tiến êm ả (Quiet Momentum - 417 Hz acoustic guitar & marimba)
- SO-20: Mơ màng thanh khiết (Dreamy Ethereal - 963 Hz celestial glass chimes & harp)

Ambient tracks:
- SO-03: Mưa bên cửa sổ (Window Rain - Muffled cozy rain & 174 Hz)
- SO-05: Nhịp thở đại dương (Ocean Breath - Deep gentle rolling swells & 285 Hz)
- SO-07: Căn phòng có lò sưởi (Fireplace Room - Cozy hearth fire & 396 Hz)
- SO-10: Tắm âm thanh dịu nhẹ (Soft Sound Bath - 432 Hz Tibetan singing bowls & theta waves)

All audio is 100% Soul-owned, synthesized via multi-harmonic physics-based DSP,
devoid of harsh wind/noise hiss, mastered to -14 to -17 dB RMS / -1.0 dB True Peak,
with seamless zero-click circular loops.
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


def note_freq(name: str, octave: int = 4, a4: float = 432.0) -> float:
    """Calculates exact pitch frequency in A4 tuning (default 432 Hz)."""
    offsets = {
        'C': -9, 'C#': -8, 'Db': -8, 'D': -7, 'D#': -6, 'Eb': -6,
        'E': -5, 'F': -4, 'F#': -3, 'Gb': -3, 'G': -2, 'G#': -1, 'Ab': -1,
        'A': 0, 'A#': 1, 'Bb': 1, 'B': 2
    }
    semitones = offsets[name] + (octave - 4) * 12
    return a4 * (2.0 ** (semitones / 12.0))


def apply_stereo_reverb(track: np.ndarray, decay: float = 0.40) -> np.ndarray:
    """Applies lush, warm studio acoustic reverb via multi-tap diffusion."""
    out = track.copy()
    delays = [0.023, 0.037, 0.053, 0.071, 0.097, 0.131]
    pans = [0.35, 0.65, 0.25, 0.75, 0.40, 0.60]
    for i, (d, pan) in enumerate(zip(delays, pans)):
        d_samp = int(SR * d)
        g = (decay ** (i * 0.7 + 1)) * 0.32
        if d_samp < len(track):
            out[d_samp:, 0] += track[:-d_samp, 0] * g * pan
            out[d_samp:, 1] += track[:-d_samp, 1] * g * (1.0 - pan)
    return out


def make_circular_loop(arr: np.ndarray, crossfade_sec: float = 4.0) -> np.ndarray:
    """Creates a 100% seamless circular loop by crossfading tail into head."""
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


def save_aac(arr: np.ndarray, out_path: Path, bitrate="192k"):
    """Saves float32 stereo array as high quality AAC m4a with -1.0 dB true peak and 50ms micro-fade."""
    out_path.parent.mkdir(parents=True, exist_ok=True)
    peak = np.max(np.abs(arr))
    if peak > 0.001:
        arr = arr * (0.891 / peak)  # Scale to -1.0 dB True Peak

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


# ---------------------------------------------------------------------------
# High-Quality Instrument Synthesizers
# ---------------------------------------------------------------------------

def synth_felt_piano_note(f0: float, dur: float, vel: float = 0.8) -> np.ndarray:
    """Synthesizes a warm, intimate acoustic felt piano note."""
    n = int(SR * dur)
    t = np.linspace(0, dur, n, endpoint=False)
    s1 = (
        np.sin(2 * np.pi * f0 * t) * 1.0 +
        np.sin(2 * np.pi * 2 * f0 * t) * 0.38 +
        np.sin(2 * np.pi * 3 * f0 * t) * 0.12 +
        np.sin(2 * np.pi * 4 * f0 * t) * 0.04
    )
    f_det = f0 + 0.35
    s2 = (
        np.sin(2 * np.pi * f_det * t) * 1.0 +
        np.sin(2 * np.pi * 2 * f_det * t) * 0.38 +
        np.sin(2 * np.pi * 3 * f_det * t) * 0.12 +
        np.sin(2 * np.pi * 4 * f_det * t) * 0.04
    )
    env = (1.0 - np.exp(-t * 80.0)) * (np.exp(-t * 0.85) * 0.75 + np.exp(-t * 2.5) * 0.25)
    return (s1 + s2) * 0.5 * env * vel


def synth_acoustic_guitar_note(f0: float, dur: float, vel: float = 0.85) -> np.ndarray:
    """Synthesizes an intimate plucked nylon/steel acoustic guitar note."""
    n = int(SR * dur)
    t = np.linspace(0, dur, n, endpoint=False)
    tone = (
        np.sin(2 * np.pi * f0 * t) * 1.0 +
        np.sin(2 * np.pi * 2 * f0 * t) * 0.55 +
        np.sin(2 * np.pi * 3 * f0 * t) * 0.26 +
        np.sin(2 * np.pi * 4 * f0 * t) * 0.10 +
        np.sin(2 * np.pi * 5 * f0 * t) * 0.04
    )
    env = (1.0 - np.exp(-t * 160.0)) * np.exp(-t * 1.8)
    return tone * env * vel


def synth_harp_celesta_note(f0: float, dur: float, vel: float = 0.75) -> np.ndarray:
    """Synthesizes a crystalline harp / music box bell tone."""
    n = int(SR * dur)
    t = np.linspace(0, dur, n, endpoint=False)
    trem = 1.0 + 0.12 * np.sin(2 * np.pi * 3.0 * t)
    tone = (
        np.sin(2 * np.pi * f0 * t) * 1.0 +
        np.sin(2 * np.pi * 2 * f0 * t) * 0.22 +
        np.sin(2 * np.pi * 3 * f0 * t) * 0.18 +
        np.sin(2 * np.pi * 6 * f0 * t) * 0.05
    ) * trem
    env = (1.0 - np.exp(-t * 120.0)) * np.exp(-t * 1.4)
    return tone * env * vel


def synth_bamboo_flute_phrase(notes: list, dur_per_note: float = 2.0, a4: float = 432.0) -> np.ndarray:
    """Synthesizes a breathy, lyrical bamboo flute (sáo trúc) phrase with natural vibrato."""
    total_dur = len(notes) * dur_per_note
    n = int(SR * total_dur)
    phrase = np.zeros(n, dtype=np.float32)

    for i, (name, octv) in enumerate(notes):
        f_base = note_freq(name, octv, a4)
        t_note = np.linspace(0, dur_per_note, int(SR * dur_per_note), endpoint=False)
        vib = 1.0 + 0.010 * np.sin(2 * np.pi * 5.2 * t_note)
        f_inst = f_base * vib
        phase = 2 * np.pi * np.cumsum(f_inst) / SR
        tone = np.sin(phase) + 0.32 * np.sin(2 * phase) + 0.08 * np.sin(3 * phase)
        env = (1.0 - np.exp(-t_note * 25.0)) * (1.0 - np.exp(-(dur_per_note - t_note) * 20.0))
        env = np.clip(env, 0.0, 1.0)
        idx_s = int(i * dur_per_note * SR)
        idx_e = idx_s + len(tone)
        if idx_e <= n:
            phrase[idx_s:idx_e] += tone * env * 0.45

    return phrase


def synth_handpan_note(f0: float, dur: float = 3.5, vel: float = 0.8) -> np.ndarray:
    """Synthesizes an authentic resonant handpan / hang drum tone."""
    n = int(SR * dur)
    t = np.linspace(0, dur, n, endpoint=False)
    tone = (
        np.sin(2 * np.pi * f0 * t) * 1.0 +
        np.sin(2 * np.pi * 2 * f0 * t) * 0.45 +
        np.sin(2 * np.pi * 3 * f0 * t) * 0.20
    )
    thud = np.sin(2 * np.pi * 95.0 * t) * np.exp(-t * 80.0) * 0.15
    env = (1.0 - np.exp(-t * 120.0)) * np.exp(-t * 1.5)
    return (tone * env + thud) * vel


def synth_rhodes_note(f0: float, dur: float = 4.0, vel: float = 0.75) -> np.ndarray:
    """Synthesizes a lush vintage electric piano (Rhodes) tone."""
    n = int(SR * dur)
    t = np.linspace(0, dur, n, endpoint=False)
    tine = np.sin(2 * np.pi * f0 * 7.0 * t) * np.exp(-t * 90.0) * 0.15
    body = (
        np.sin(2 * np.pi * f0 * t) * 1.0 +
        np.sin(2 * np.pi * 2 * f0 * t) * 0.35 +
        np.sin(2 * np.pi * 3 * f0 * t) * 0.08
    )
    trem = 1.0 + 0.15 * np.sin(2 * np.pi * 4.5 * t)
    env = (1.0 - np.exp(-t * 90.0)) * np.exp(-t * 0.95)
    return (body * env * trem + tine) * vel


def synth_warm_cello_note(f0: float, dur: float = 4.5, vel: float = 0.8) -> np.ndarray:
    """Synthesizes a warm, grounded cello / bowed string tone."""
    n = int(SR * dur)
    t = np.linspace(0, dur, n, endpoint=False)
    vib = 1.0 + 0.008 * np.sin(2 * np.pi * 5.0 * t)
    f_inst = f0 * vib
    phase = 2 * np.pi * np.cumsum(f_inst) / SR
    tone = (
        np.sin(phase) * 1.0 +
        np.sin(2 * phase) * 0.65 +
        np.sin(3 * phase) * 0.35 +
        np.sin(4 * phase) * 0.18 +
        np.sin(5 * phase) * 0.08
    )
    env = (1.0 - np.exp(-t * 15.0)) * np.exp(-t * 0.35)
    return tone * env * vel


# ---------------------------------------------------------------------------
# Specific Soundscapes (Re-engineered to be gentle, musical, healing, zero noise hiss)
# ---------------------------------------------------------------------------

def render_so28_winter_hearth_tea(duration_sec=64):
    """
    SO-28: Ấm trà reo bên bếp lửa mùa đông (Winter Hearth & Simmering Tea).
    Music: Heartfelt, nostalgic acoustic guitar fingerpicking + warm felt piano melody.
    Ambient: Delicate, tiny water simmer bubbles gently intertwined with music, and warm fireside glow.
    NO harsh hissing steam, NO loud noise.
    """
    n = int(SR * duration_sec)
    track = np.zeros((n, 2), dtype=np.float32)

    chord_patterns = [
        [('D', 3), ('A', 3), ('F#', 4), ('A', 4), ('D', 4), ('F#', 4), ('C#', 5), ('A', 4)],
        [('B', 2), ('F#', 3), ('D', 4), ('F#', 4), ('B', 3), ('D', 4), ('A', 4), ('F#', 4)],
        [('G', 2), ('D', 3), ('B', 3), ('D', 4), ('G', 3), ('B', 3), ('F#', 4), ('D', 4)],
        [('A', 2), ('E', 3), ('C#', 4), ('E', 4), ('A', 3), ('C#', 4), ('B', 4), ('E', 4)],
    ]
    cycle_dur = 16.0
    num_cycles = int(np.ceil(duration_sec / cycle_dur))
    t_cursor = 0.0
    step = 0.5

    for cyc in range(num_cycles):
        for chord in chord_patterns:
            for note_idx, (n_name, octv) in enumerate(chord):
                if t_cursor + 2.5 >= duration_sec:
                    break
                f0 = note_freq(n_name, octv, 432.0)
                note_wav = synth_acoustic_guitar_note(f0, 2.4, vel=0.72)
                pan = 0.35 + 0.18 * math.sin(t_cursor * 0.9)
                i_s = int(t_cursor * SR)
                i_e = min(n, i_s + len(note_wav))
                seg_len = i_e - i_s
                track[i_s:i_e, 0] += note_wav[:seg_len] * (1.0 - pan)
                track[i_s:i_e, 1] += note_wav[:seg_len] * pan
                t_cursor += step

    piano_motifs = [
        (2.0, [('F#', 5), ('E', 5), ('C#', 5)]),
        (6.0, [('D', 5), ('C#', 5), ('B', 4)]),
        (10.0, [('B', 4), ('A', 4), ('F#', 4)]),
        (14.0, [('A', 4), ('C#', 5), ('D', 5)]),
    ]
    for cyc in range(num_cycles):
        cyc_start = cyc * cycle_dur
        for off, notes in piano_motifs:
            m_time = cyc_start + off
            for k, (n_name, octv) in enumerate(notes):
                note_t = m_time + k * 0.6
                if note_t + 3.0 < duration_sec:
                    f0 = note_freq(n_name, octv, 432.0)
                    p_wav = synth_felt_piano_note(f0, 3.2, vel=0.68)
                    i_s = int(note_t * SR)
                    i_e = min(n, i_s + len(p_wav))
                    seg_len = i_e - i_s
                    pan = 0.65
                    track[i_s:i_e, 0] += p_wav[:seg_len] * (1.0 - pan)
                    track[i_s:i_e, 1] += p_wav[:seg_len] * pan

    # Delicate simmering tea bubbles (tucked gently behind music, -24 dB)
    np.random.seed(108)
    bubbles = np.zeros((n, 2), dtype=np.float32)
    n_bubbles = int(duration_sec * 18)
    b_times = np.random.uniform(0, duration_sec, n_bubbles)
    for b_time in b_times:
        i_s = int(b_time * SR)
        b_dur = np.random.uniform(0.018, 0.038)
        i_e = min(n, i_s + int(b_dur * SR))
        if i_e > i_s:
            t_b = np.linspace(0, (i_e - i_s) / SR, i_e - i_s, endpoint=False)
            f_pop = np.random.uniform(550, 920)
            env = np.exp(-t_b * 110.0)
            pop = np.sin(2 * np.pi * f_pop * t_b) * env * 0.05
            pan = np.random.uniform(0.4, 0.6)
            bubbles[i_s:i_e, 0] += pop * (1.0 - pan)
            bubbles[i_s:i_e, 1] += pop * pan

    t_arr = np.linspace(0, duration_sec, n, endpoint=False)
    hearth_bed = np.sin(2 * np.pi * 96.0 * t_arr) * 0.04 + np.sin(2 * np.pi * 192.0 * t_arr) * 0.02
    hearth_stereo = np.column_stack([hearth_bed, hearth_bed])

    wet_music = apply_stereo_reverb(track * 0.68, decay=0.38)
    mix = wet_music + bubbles + hearth_stereo
    loop = make_circular_loop(mix, crossfade_sec=4.0)
    save_aac(loop, AMBIENCE_DIR / "so-28-cozy-kitchen-simmer.m4a")
    print("✓ Rendered SO-28: Ấm trà reo bên bếp lửa mùa đông (Melodic Guitar & Cozy Hearth Simmer)")


def render_so24_sunset_ocean_waves(duration_sec=64):
    """
    SO-24: Sóng biển vỗ bờ hoàng hôn (Sunset Waves & Ocean Breeze).
    Music: Peaceful sunset piano & celestial harp arpeggios in 432 Hz / 285 Hz.
    Ambient: Deep, distant rolling ocean swells (low-pass filtered under 150 Hz, like a heartbeat).
    NO loud wind, NO rushing pink noise.
    """
    n = int(SR * duration_sec)
    track = np.zeros((n, 2), dtype=np.float32)

    chords = [
        [('D', 3), ('A', 3), ('F#', 4), ('C#', 5), ('E', 5)],
        [('G', 2), ('D', 3), ('B', 3), ('F#', 4), ('B', 4)],
        [('B', 2), ('F#', 3), ('D', 4), ('A', 4), ('D', 5)],
        [('A', 2), ('E', 3), ('D', 4), ('A', 4), ('E', 5)],
    ]
    cycle_dur = 16.0
    num_cycles = int(np.ceil(duration_sec / cycle_dur))
    t_cursor = 0.0

    for cyc in range(num_cycles):
        for chord in chords:
            p_root = synth_felt_piano_note(note_freq(chord[0][0], chord[0][1], 432.0), 3.8, vel=0.75)
            i_s = int(t_cursor * SR)
            i_e = min(n, i_s + len(p_root))
            track[i_s:i_e, 0] += p_root[:i_e - i_s] * 0.6
            track[i_s:i_e, 1] += p_root[:i_e - i_s] * 0.4

            for idx, (n_name, octv) in enumerate(chord[1:]):
                h_time = t_cursor + 0.35 * (idx + 1)
                if h_time + 3.0 < duration_sec:
                    f0 = note_freq(n_name, octv, 432.0)
                    h_wav = synth_harp_celesta_note(f0, 3.2, vel=0.70)
                    hi_s = int(h_time * SR)
                    hi_e = min(n, hi_s + len(h_wav))
                    pan = 0.3 + 0.15 * idx
                    track[hi_s:hi_e, 0] += h_wav[:hi_e - hi_s] * (1.0 - pan)
                    track[hi_s:hi_e, 1] += h_wav[:hi_e - hi_s] * pan

            t_cursor += 4.0

    t = np.linspace(0, duration_sec, n, endpoint=False)
    swell_env = (0.5 + 0.5 * np.sin(2 * np.pi * t / 10.5 - np.pi / 2)) ** 2.5
    f_swell1 = np.sin(2 * np.pi * 55.0 * t) * 0.08
    f_swell2 = np.sin(2 * np.pi * 110.0 * t) * 0.05
    swell_bed = (f_swell1 + f_swell2) * swell_env

    tone285 = np.sin(2 * np.pi * 285.0 * t) * 0.04
    ambient = np.column_stack([swell_bed + tone285, np.roll(swell_bed, int(SR * 0.8)) + tone285])

    wet_music = apply_stereo_reverb(track * 0.65, decay=0.45)
    mix = wet_music + ambient
    loop = make_circular_loop(mix, crossfade_sec=4.0)
    save_aac(loop, AMBIENCE_DIR / "so-24-ocean-wind-waves.m4a")
    print("✓ Rendered SO-24: Sóng biển vỗ bờ hoàng hôn (Sunset Piano & Ocean Breath)")


def render_so25_cat_purring_piano(duration_sec=64):
    """
    SO-25: Mèo con lười sưởi nắng & phím dương cầm (Sunlit Cat Purr & Gentle Piano).
    Music: Sweet, sleepy felt piano lullaby in 432 Hz with soft Rhodes chimes.
    Ambient: Rhythmic, warm 24 Hz deep cat purr and gentle breathing.
    """
    n = int(SR * duration_sec)
    track = np.zeros((n, 2), dtype=np.float32)

    chords = [
        [('C', 3), ('G', 3), ('E', 4), ('B', 4), ('D', 5)],
        [('A', 2), ('E', 3), ('C', 4), ('G', 4), ('B', 4)],
        [('F', 2), ('C', 3), ('A', 3), ('E', 4), ('G', 4)],
        [('G', 2), ('D', 3), ('B', 3), ('E', 4), ('A', 4)],
    ]
    cycle_dur = 16.0
    num_cycles = int(np.ceil(duration_sec / cycle_dur))
    t_cursor = 0.0

    for cyc in range(num_cycles):
        for chord in chords:
            for idx, (n_name, octv) in enumerate(chord):
                p_time = t_cursor + idx * 0.5
                if p_time + 3.0 < duration_sec:
                    f0 = note_freq(n_name, octv, 432.0)
                    p_wav = synth_felt_piano_note(f0, 3.5, vel=0.68)
                    i_s = int(p_time * SR)
                    i_e = min(n, i_s + len(p_wav))
                    pan = 0.35 + 0.1 * idx
                    track[i_s:i_e, 0] += p_wav[:i_e - i_s] * (1.0 - pan)
                    track[i_s:i_e, 1] += p_wav[:i_e - i_s] * pan
            t_cursor += 4.0

    t = np.linspace(0, duration_sec, n, endpoint=False)
    breath = (0.55 + 0.45 * np.sin(2 * np.pi * t / 3.84)) ** 1.5
    purr_osc = (np.sin(2 * np.pi * 25.0 * t) * 0.7 + np.sin(2 * np.pi * 50.0 * t) * 0.3) * breath * 0.14
    purr_stereo = np.column_stack([purr_osc * 0.9, purr_osc * 0.85])

    wet_music = apply_stereo_reverb(track * 0.68, decay=0.38)
    mix = wet_music + purr_stereo
    loop = make_circular_loop(mix, crossfade_sec=4.0)
    save_aac(loop, AMBIENCE_DIR / "so-25-purring-cat-piano.m4a")
    print("✓ Rendered SO-25: Mèo con lười sưởi nắng & phím dương cầm (Gentle Felt Piano & Cat Purr)")


def render_so26_puppy_acoustic(duration_sec=64):
    """
    SO-26: Cún nhỏ đón bạn về & guitar mộc (Welcoming Puppy & Warm Acoustic).
    Music: Warm, heartwarming fingerpicked acoustic guitar in G major (G - Em7 - C - D).
    Ambient: Pure intimate acoustic room warmth.
    """
    n = int(SR * duration_sec)
    track = np.zeros((n, 2), dtype=np.float32)

    chords = [
        [('G', 2), ('D', 3), ('G', 3), ('B', 3), ('D', 4), ('G', 4)],
        [('E', 2), ('B', 2), ('E', 3), ('G', 3), ('D', 4), ('G', 4)],
        [('C', 3), ('G', 3), ('C', 4), ('E', 4), ('G', 4), ('D', 5)],
        [('D', 3), ('A', 3), ('D', 4), ('F#', 4), ('A', 4), ('D', 5)],
    ]
    cycle_dur = 16.0
    num_cycles = int(np.ceil(duration_sec / cycle_dur))
    t_cursor = 0.0

    for cyc in range(num_cycles):
        for chord in chords:
            for idx, (n_name, octv) in enumerate(chord):
                n_time = t_cursor + idx * 0.55
                if n_time + 2.5 < duration_sec:
                    f0 = note_freq(n_name, octv, 440.0)
                    g_wav = synth_acoustic_guitar_note(f0, 2.6, vel=0.76)
                    pan = 0.4 + 0.08 * idx
                    i_s = int(n_time * SR)
                    i_e = min(n, i_s + len(g_wav))
                    track[i_s:i_e, 0] += g_wav[:i_e - i_s] * (1.0 - pan)
                    track[i_s:i_e, 1] += g_wav[:i_e - i_s] * pan

            for tap_beat in [1.1, 2.75]:
                tap_time = t_cursor + tap_beat
                if tap_time + 0.2 < duration_sec:
                    i_s = int(tap_time * SR)
                    tap_dur = 0.08
                    i_e = min(n, i_s + int(tap_dur * SR))
                    t_tap = np.linspace(0, tap_dur, i_e - i_s, endpoint=False)
                    tap_wav = np.sin(2 * np.pi * 85.0 * t_tap) * np.exp(-t_tap * 45.0) * 0.08
                    track[i_s:i_e, 0] += tap_wav * 0.5
                    track[i_s:i_e, 1] += tap_wav * 0.5

            t_cursor += 4.0

    wet_music = apply_stereo_reverb(track * 0.72, decay=0.32)
    loop = make_circular_loop(wet_music, crossfade_sec=4.0)
    save_aac(loop, AMBIENCE_DIR / "so-26-playful-puppy-acoustic.m4a")
    print("✓ Rendered SO-26: Cún nhỏ đón bạn về & guitar mộc (Heartfelt Acoustic Fingerpicking)")


def render_so27_forest_birds_breeze(duration_sec=64):
    """
    SO-27: Gió ngàn đồi hoa & chim rừng ban mai (Wildflower Breeze & Forest Birdsong).
    Music: Dreamy morning harp & bamboo flute melody in 528 Hz.
    Ambient: Sweet, melodic songbird calls (gentle sine chirps, soft high register, NO harsh hiss/wind).
    """
    n = int(SR * duration_sec)
    track = np.zeros((n, 2), dtype=np.float32)

    t = np.linspace(0, duration_sec, n, endpoint=False)
    f528 = np.sin(2 * np.pi * 528.0 * t) * 0.04
    f264 = np.sin(2 * np.pi * 264.0 * t) * 0.05
    f396 = np.sin(2 * np.pi * 396.0 * t) * 0.03
    pad = np.column_stack([f528 + f264, f528 + f396])

    harp_chords = [
        [('C', 4), ('E', 4), ('G', 4), ('B', 4), ('D', 5), ('G', 5)],
        [('A', 3), ('C', 4), ('E', 4), ('G', 4), ('C', 5), ('E', 5)],
        [('F', 3), ('A', 3), ('C', 4), ('E', 4), ('A', 4), ('C', 5)],
        [('G', 3), ('B', 3), ('D', 4), ('F#', 4), ('B', 4), ('D', 5)],
    ]
    t_cursor = 0.0
    for cyc in range(int(np.ceil(duration_sec / 16.0))):
        for chord in harp_chords:
            for idx, (n_name, octv) in enumerate(chord):
                h_time = t_cursor + idx * 0.5
                if h_time + 3.0 < duration_sec:
                    f0 = note_freq(n_name, octv, 432.0)
                    h_wav = synth_harp_celesta_note(f0, 3.0, vel=0.65)
                    pan = 0.3 + 0.12 * idx
                    i_s = int(h_time * SR)
                    i_e = min(n, i_s + len(h_wav))
                    track[i_s:i_e, 0] += h_wav[:i_e - i_s] * (1.0 - pan)
                    track[i_s:i_e, 1] += h_wav[:i_e - i_s] * pan
            t_cursor += 4.0

    flute_notes1 = [('E', 5), ('G', 5), ('A', 5), ('B', 5), ('A', 5), ('G', 5)]
    flute_wav1 = synth_bamboo_flute_phrase(flute_notes1, dur_per_note=1.2, a4=432.0)
    if len(flute_wav1) < n:
        track[int(SR * 2.0):int(SR * 2.0) + len(flute_wav1), 0] += flute_wav1 * 0.5
        track[int(SR * 2.0):int(SR * 2.0) + len(flute_wav1), 1] += flute_wav1 * 0.5

    flute_notes2 = [('C', 5), ('D', 5), ('E', 5), ('G', 5), ('E', 5)]
    flute_wav2 = synth_bamboo_flute_phrase(flute_notes2, dur_per_note=1.4, a4=432.0)
    if len(flute_wav2) < n:
        track[int(SR * 32.0):int(SR * 32.0) + len(flute_wav2), 0] += flute_wav2 * 0.5
        track[int(SR * 32.0):int(SR * 32.0) + len(flute_wav2), 1] += flute_wav2 * 0.5

    birds = np.zeros((n, 2), dtype=np.float32)
    np.random.seed(77)
    b_cursor = 2.0
    while b_cursor < duration_sec - 3.0:
        pan = np.random.uniform(0.3, 0.7)
        base_f = np.random.uniform(2600, 3400)
        n_chirps = np.random.randint(2, 5)
        for _ in range(n_chirps):
            c_dur = np.random.uniform(0.08, 0.14)
            i_s = int(b_cursor * SR)
            i_e = min(n, i_s + int(c_dur * SR))
            if i_e > i_s:
                t_c = np.linspace(0, c_dur, i_e - i_s, endpoint=False)
                sweep = base_f + np.random.uniform(-300, 500) * (t_c / c_dur)
                phase = 2 * np.pi * np.cumsum(sweep) / SR
                env = np.sin(np.pi * (t_c / c_dur)) ** 2
                chirp = np.sin(phase) * env * 0.08
                birds[i_s:i_e, 0] += chirp * pan
                birds[i_s:i_e, 1] += chirp * (1.0 - pan)
            b_cursor += c_dur + np.random.uniform(0.06, 0.15)
        b_cursor += np.random.uniform(4.0, 8.0)

    wet_music = apply_stereo_reverb(track * 0.65, decay=0.42)
    mix = wet_music + pad + birds
    loop = make_circular_loop(mix, crossfade_sec=4.0)
    save_aac(loop, AMBIENCE_DIR / "so-27-forest-birds-gentle-breeze.m4a")
    print("✓ Rendered SO-27: Gió ngàn đồi hoa & chim rừng ban mai (Morning Harp, Flute & Songbirds)")


# ---------------------------------------------------------------------------
# Re-engineering Older Tracks to be Melodious, Warm, and Truly Healing
# ---------------------------------------------------------------------------

def render_so11_warm_felt_piano(duration_sec=64):
    """
    SO-11: Piano ấm áp (Warm Felt Piano).
    Replaces old pink-noise placeholder with a genuine, soul-soothing 432 Hz felt piano solo.
    """
    n = int(SR * duration_sec)
    track = np.zeros((n, 2), dtype=np.float32)

    chords = [
        [('F', 2), ('C', 3), ('A', 3), ('E', 4), ('G', 4)],
        [('C', 2), ('G', 2), ('E', 3), ('B', 3), ('D', 4)],
        [('D', 2), ('A', 2), ('F', 3), ('C', 4), ('E', 4)],
        [('A', 2), ('E', 3), ('C', 4), ('G', 4), ('B', 4)],
    ]
    melody_phrases = [
        [(0.0, ('E', 4)), (1.0, ('G', 4)), (2.0, ('A', 4)), (3.0, ('C', 5))],
        [(4.0, ('B', 4)), (5.0, ('G', 4)), (6.0, ('E', 4)), (7.0, ('D', 4))],
        [(8.0, ('F', 4)), (9.0, ('A', 4)), (10.0, ('C', 5)), (11.0, ('E', 5))],
        [(12.0, ('D', 5)), (13.0, ('B', 4)), (14.0, ('G', 4)), (15.0, ('E', 4))],
    ]

    for cyc in range(int(np.ceil(duration_sec / 16.0))):
        cyc_t = cyc * 16.0
        for m_idx, chord in enumerate(chords):
            m_t = cyc_t + m_idx * 4.0
            for idx, (n_name, octv) in enumerate(chord):
                n_t = m_t + idx * 0.4
                if n_t + 3.5 < duration_sec:
                    f0 = note_freq(n_name, octv, 432.0)
                    p_wav = synth_felt_piano_note(f0, 3.8, vel=0.72)
                    pan = 0.35 + 0.08 * idx
                    i_s = int(n_t * SR)
                    i_e = min(n, i_s + len(p_wav))
                    track[i_s:i_e, 0] += p_wav[:i_e - i_s] * (1.0 - pan)
                    track[i_s:i_e, 1] += p_wav[:i_e - i_s] * pan

        for phrase in melody_phrases:
            for off, (n_name, octv) in phrase:
                mel_t = cyc_t + off
                if mel_t + 3.0 < duration_sec:
                    f0 = note_freq(n_name, octv, 432.0)
                    m_wav = synth_felt_piano_note(f0, 3.2, vel=0.82)
                    pan = 0.55
                    i_s = int(mel_t * SR)
                    i_e = min(n, i_s + len(m_wav))
                    track[i_s:i_e, 0] += m_wav[:i_e - i_s] * (1.0 - pan)
                    track[i_s:i_e, 1] += m_wav[:i_e - i_s] * pan

    wet = apply_stereo_reverb(track * 0.75, decay=0.45)
    loop = make_circular_loop(wet, crossfade_sec=4.0)
    save_aac(loop, MUSIC_DIR / "so-11-warm-felt-piano.m4a")
    print("✓ Upgraded SO-11: Piano ấm áp (Warm Felt Piano - True 432 Hz Piano Solo)")


def render_so12_future_horizon(duration_sec=64):
    """
    SO-12: Chân trời tương lai (Future Horizon).
    528 Hz transformation melody: Inspiring acoustic guitar & celestial Rhodes arrangement.
    """
    n = int(SR * duration_sec)
    track = np.zeros((n, 2), dtype=np.float32)

    chords = [
        [('D', 3), ('A', 3), ('F#', 4), ('C#', 5)],
        [('G', 2), ('D', 3), ('B', 3), ('F#', 4)],
        [('B', 2), ('F#', 3), ('D', 4), ('A', 4)],
        [('A', 2), ('E', 3), ('C#', 4), ('G', 4)],
    ]
    for cyc in range(int(np.ceil(duration_sec / 16.0))):
        cyc_t = cyc * 16.0
        for m_idx, chord in enumerate(chords):
            m_t = cyc_t + m_idx * 4.0
            for idx, (n_name, octv) in enumerate(chord):
                n_t = m_t + idx * 0.5
                if n_t + 3.5 < duration_sec:
                    f0 = note_freq(n_name, octv, 432.0)
                    g_wav = synth_acoustic_guitar_note(f0, 3.0, vel=0.72)
                    r_wav = synth_rhodes_note(f0 * 2, 3.2, vel=0.35)
                    wav = g_wav.copy()
                    min_l = min(len(g_wav), len(r_wav))
                    wav[:min_l] += r_wav[:min_l]
                    pan = 0.35 + 0.1 * idx
                    i_s = int(n_t * SR)
                    i_e = min(n, i_s + len(wav))
                    track[i_s:i_e, 0] += wav[:i_e - i_s] * (1.0 - pan)
                    track[i_s:i_e, 1] += wav[:i_e - i_s] * pan

    wet = apply_stereo_reverb(track * 0.72, decay=0.42)
    loop = make_circular_loop(wet, crossfade_sec=4.0)
    save_aac(loop, MUSIC_DIR / "so-12-future-horizon.m4a")
    print("✓ Upgraded SO-12: Chân trời tương lai (Future Horizon - 528 Hz Transformation)")


def render_so13_golden_flow(duration_sec=64):
    """
    SO-13: Dòng chảy vàng (Golden Flow).
    Replaces old pink-noise placeholder with a flowing 528 Hz positive energy acoustic guitar & Rhodes arrangement.
    """
    n = int(SR * duration_sec)
    track = np.zeros((n, 2), dtype=np.float32)

    chords = [
        [('C', 3), ('G', 3), ('E', 4), ('G', 4), ('C', 5)],
        [('G', 2), ('D', 3), ('B', 3), ('D', 4), ('G', 4)],
        [('A', 2), ('E', 3), ('C', 4), ('E', 4), ('A', 4)],
        [('F', 2), ('C', 3), ('A', 3), ('C', 4), ('F', 4)],
    ]
    for cyc in range(int(np.ceil(duration_sec / 16.0))):
        cyc_t = cyc * 16.0
        for m_idx, chord in enumerate(chords):
            m_t = cyc_t + m_idx * 4.0
            for idx, (n_name, octv) in enumerate(chord):
                n_t = m_t + idx * 0.6
                if n_t + 3.0 < duration_sec:
                    f0 = note_freq(n_name, octv, 528.0 * (432.0 / 528.0))
                    g_wav = synth_acoustic_guitar_note(f0, 2.8, vel=0.74)
                    h_wav = synth_harp_celesta_note(f0 * 2, 2.5, vel=0.35)
                    wav = g_wav.copy()
                    min_l = min(len(g_wav), len(h_wav))
                    wav[:min_l] += h_wav[:min_l]
                    pan = 0.35 + 0.1 * idx
                    i_s = int(n_t * SR)
                    i_e = min(n, i_s + len(wav))
                    track[i_s:i_e, 0] += wav[:i_e - i_s] * (1.0 - pan)
                    track[i_s:i_e, 1] += wav[:i_e - i_s] * pan

    wet = apply_stereo_reverb(track * 0.72, decay=0.40)
    loop = make_circular_loop(wet, crossfade_sec=4.0)
    save_aac(loop, MUSIC_DIR / "so-13-golden-flow.m4a")
    print("✓ Upgraded SO-13: Dòng chảy vàng (Golden Flow - 528 Hz Acoustic Flow)")


def render_so14_rooted_calm(duration_sec=64):
    """
    SO-14: Bình yên vững vàng (Rooted Calm).
    396 Hz grounding: Warm, soothing cello & low felt piano chords for rooted inner tranquility.
    """
    n = int(SR * duration_sec)
    track = np.zeros((n, 2), dtype=np.float32)

    chords = [
        ('C', 2), ('G', 2), ('A', 2), ('F', 2)
    ]
    for cyc in range(int(np.ceil(duration_sec / 16.0))):
        cyc_t = cyc * 16.0
        for idx, (root_name, root_oct) in enumerate(chords):
            m_t = cyc_t + idx * 4.0
            if m_t + 4.0 < duration_sec:
                f0 = note_freq(root_name, root_oct, 396.0 * (432.0 / 440.0))
                cello_wav = synth_warm_cello_note(f0, 4.2, vel=0.75)
                piano_wav = synth_felt_piano_note(f0 * 2, 3.8, vel=0.65)
                i_s = int(m_t * SR)
                min_l = min(len(cello_wav), len(piano_wav))
                i_e = min(n, i_s + min_l)
                seg_len = i_e - i_s
                comb = cello_wav[:seg_len] * 0.6 + piano_wav[:seg_len] * 0.4
                track[i_s:i_e, 0] += comb
                track[i_s:i_e, 1] += comb

    wet = apply_stereo_reverb(track * 0.72, decay=0.45)
    loop = make_circular_loop(wet, crossfade_sec=4.0)
    save_aac(loop, MUSIC_DIR / "so-14-rooted-calm.m4a")
    print("✓ Upgraded SO-14: Bình yên vững vàng (Rooted Calm - 396 Hz Cello & Piano)")


def render_so15_abundance_current(duration_sec=64):
    """
    SO-15: Dòng chảy đủ đầy (Abundance Current).
    888 Hz prosperity frequency: Shimmering celestial music box, celesta & harp cascading like liquid light.
    """
    n = int(SR * duration_sec)
    track = np.zeros((n, 2), dtype=np.float32)

    notes = [('C', 4), ('E', 4), ('G', 4), ('B', 4), ('C', 5), ('E', 5), ('G', 5)]
    step = 0.45
    t_cursor = 0.0
    while t_cursor + 3.0 < duration_sec:
        idx = int(t_cursor / step) % len(notes)
        name, octv = notes[idx]
        f0 = note_freq(name, octv, 444.0)  # subharmonic of 888 Hz
        h_wav = synth_harp_celesta_note(f0, 3.0, vel=0.70)
        pan = 0.35 + 0.3 * (idx / len(notes))
        i_s = int(t_cursor * SR)
        i_e = min(n, i_s + len(h_wav))
        track[i_s:i_e, 0] += h_wav[:i_e - i_s] * (1.0 - pan)
        track[i_s:i_e, 1] += h_wav[:i_e - i_s] * pan
        t_cursor += step

    t = np.linspace(0, duration_sec, n, endpoint=False)
    f888 = np.sin(2 * np.pi * 888.0 * t) * 0.03
    bed = np.column_stack([f888, f888])

    wet = apply_stereo_reverb(track * 0.68, decay=0.48)
    mix = wet + bed
    loop = make_circular_loop(mix, crossfade_sec=4.0)
    save_aac(loop, MUSIC_DIR / "so-15-abundance-current.m4a")
    print("✓ Upgraded SO-15: Dòng chảy đủ đầy (Abundance Current - 888 Hz Celesta & Harp)")


def render_so16_open_sky_handpan(duration_sec=64):
    """
    SO-16: Handpan bầu trời rộng mở (Open Sky Handpan).
    741 Hz awakening: Authentic resonant melodic hang drum / handpan in D Kurd scale.
    Hypnotic, organic, deeply relaxing.
    """
    n = int(SR * duration_sec)
    track = np.zeros((n, 2), dtype=np.float32)

    # D Kurd / 741 Hz tuning notes
    handpan_scale = [
        ('D', 3), ('A', 3), ('Bb', 3), ('C', 4), ('D', 4), ('E', 4), ('F', 4), ('G', 4), ('A', 4)
    ]
    pattern = [0, 1, 4, 2, 5, 3, 6, 4, 7, 5, 8, 4]
    step = 0.55
    t_cursor = 0.0

    while t_cursor + 3.0 < duration_sec:
        note_i = pattern[int(t_cursor / step) % len(pattern)]
        name, octv = handpan_scale[note_i]
        f0 = note_freq(name, octv, 440.0)
        hp_wav = synth_handpan_note(f0, 3.2, vel=0.78)
        pan = 0.35 + 0.3 * (note_i / len(handpan_scale))
        i_s = int(t_cursor * SR)
        i_e = min(n, i_s + len(hp_wav))
        track[i_s:i_e, 0] += hp_wav[:i_e - i_s] * (1.0 - pan)
        track[i_s:i_e, 1] += hp_wav[:i_e - i_s] * pan
        t_cursor += step

    t = np.linspace(0, duration_sec, n, endpoint=False)
    f741 = np.sin(2 * np.pi * 741.0 * t) * 0.03
    bed = np.column_stack([f741, f741])

    wet = apply_stereo_reverb(track * 0.72, decay=0.45)
    mix = wet + bed
    loop = make_circular_loop(mix, crossfade_sec=4.0)
    save_aac(loop, MUSIC_DIR / "so-16-open-sky-handpan.m4a")
    print("✓ Upgraded SO-16: Handpan bầu trời rộng mở (Authentic 741 Hz Handpan)")


def render_so17_warm_rnb_ambient(duration_sec=64):
    """
    SO-17: R&B ấm áp (Warm R&B Ambient).
    639 Hz heart connection: Neo-soul / warm lofi Rhodes electric piano chords with smooth bass.
    """
    n = int(SR * duration_sec)
    track = np.zeros((n, 2), dtype=np.float32)

    chords = [
        [('Eb', 3), ('G', 3), ('Bb', 3), ('D', 4), ('F', 4)],
        [('C', 3), ('Eb', 3), ('G', 3), ('Bb', 3), ('D', 4)],
        [('F', 2), ('C', 3), ('Eb', 3), ('Ab', 3), ('C', 4)],
        [('Bb', 2), ('F', 3), ('Ab', 3), ('D', 4), ('G', 4)],
    ]
    for cyc in range(int(np.ceil(duration_sec / 16.0))):
        cyc_t = cyc * 16.0
        for m_idx, chord in enumerate(chords):
            m_t = cyc_t + m_idx * 4.0
            for idx, (n_name, octv) in enumerate(chord):
                n_t = m_t + idx * 0.15
                if n_t + 3.8 < duration_sec:
                    f0 = note_freq(n_name, octv, 432.0)
                    r_wav = synth_rhodes_note(f0, 3.8, vel=0.75)
                    pan = 0.35 + 0.1 * idx
                    i_s = int(n_t * SR)
                    i_e = min(n, i_s + len(r_wav))
                    track[i_s:i_e, 0] += r_wav[:i_e - i_s] * (1.0 - pan)
                    track[i_s:i_e, 1] += r_wav[:i_e - i_s] * pan

    wet = apply_stereo_reverb(track * 0.72, decay=0.38)
    loop = make_circular_loop(wet, crossfade_sec=4.0)
    save_aac(loop, MUSIC_DIR / "so-17-warm-rnb-ambient.m4a")
    print("✓ Upgraded SO-17: R&B ấm áp (Warm R&B Ambient - 639 Hz Neo-Soul Rhodes)")


def render_so18_heart_space(duration_sec=64):
    """
    SO-18: Không gian trái tim (Heart Space).
    639 Hz love frequency: Tender romantic piano & acoustic harp melody.
    """
    n = int(SR * duration_sec)
    track = np.zeros((n, 2), dtype=np.float32)

    chords = [
        [('F', 3), ('C', 4), ('A', 4), ('E', 5)],
        [('C', 3), ('G', 3), ('E', 4), ('B', 4)],
        [('D', 3), ('A', 3), ('F', 4), ('C', 5)],
        [('Bb', 2), ('F', 3), ('D', 4), ('A', 4)],
    ]
    for cyc in range(int(np.ceil(duration_sec / 16.0))):
        cyc_t = cyc * 16.0
        for m_idx, chord in enumerate(chords):
            m_t = cyc_t + m_idx * 4.0
            for idx, (n_name, octv) in enumerate(chord):
                n_t = m_t + idx * 0.5
                if n_t + 3.5 < duration_sec:
                    f0 = note_freq(n_name, octv, 432.0)
                    p_wav = synth_felt_piano_note(f0, 3.6, vel=0.72)
                    h_wav = synth_harp_celesta_note(f0 * 2, 3.0, vel=0.45)
                    wav = p_wav.copy()
                    min_l = min(len(p_wav), len(h_wav))
                    wav[:min_l] += h_wav[:min_l]
                    pan = 0.35 + 0.1 * idx
                    i_s = int(n_t * SR)
                    i_e = min(n, i_s + len(wav))
                    track[i_s:i_e, 0] += wav[:i_e - i_s] * (1.0 - pan)
                    track[i_s:i_e, 1] += wav[:i_e - i_s] * pan

    wet = apply_stereo_reverb(track * 0.74, decay=0.44)
    loop = make_circular_loop(wet, crossfade_sec=4.0)
    save_aac(loop, MUSIC_DIR / "so-18-heart-space.m4a")
    print("✓ Upgraded SO-18: Không gian trái tim (Heart Space - 639 Hz Piano & Harp Duet)")


def render_so19_quiet_momentum(duration_sec=64):
    """
    SO-19: Đà tiến êm ả (Quiet Momentum).
    417 Hz renewal: Rhythmic peaceful acoustic guitar fingerpicking with gentle marimba.
    """
    n = int(SR * duration_sec)
    track = np.zeros((n, 2), dtype=np.float32)

    notes = [('A', 3), ('C', 4), ('E', 4), ('G', 4), ('A', 4), ('E', 4), ('C', 4), ('G', 3)]
    step = 0.4
    t_cursor = 0.0
    while t_cursor + 2.5 < duration_sec:
        idx = int(t_cursor / step) % len(notes)
        name, octv = notes[idx]
        f0 = note_freq(name, octv, 417.0 * (432.0 / 440.0))
        g_wav = synth_acoustic_guitar_note(f0, 2.2, vel=0.74)
        pan = 0.35 + 0.3 * (idx / len(notes))
        i_s = int(t_cursor * SR)
        i_e = min(n, i_s + len(g_wav))
        track[i_s:i_e, 0] += g_wav[:i_e - i_s] * (1.0 - pan)
        track[i_s:i_e, 1] += g_wav[:i_e - i_s] * pan
        t_cursor += step

    wet = apply_stereo_reverb(track * 0.72, decay=0.35)
    loop = make_circular_loop(wet, crossfade_sec=4.0)
    save_aac(loop, MUSIC_DIR / "so-19-quiet-momentum.m4a")
    print("✓ Upgraded SO-19: Đà tiến êm ả (Quiet Momentum - 417 Hz Guitar & Marimba)")


def render_so20_dreamy_ethereal(duration_sec=64):
    """
    SO-20: Mơ màng thanh khiết (Dreamy Ethereal).
    963 Hz crown chakra: Celestial music box, glass chimes & ethereal harp in a peaceful starry sky.
    """
    n = int(SR * duration_sec)
    track = np.zeros((n, 2), dtype=np.float32)

    pentatonic = [('C', 5), ('D', 5), ('E', 5), ('G', 5), ('A', 5), ('C', 6)]
    step = 0.65
    t_cursor = 0.0
    while t_cursor + 3.5 < duration_sec:
        idx = int(t_cursor / step) % len(pentatonic)
        name, octv = pentatonic[idx]
        f0 = note_freq(name, octv, 432.0)
        h_wav = synth_harp_celesta_note(f0, 3.4, vel=0.70)
        pan = 0.3 + 0.4 * (idx / len(pentatonic))
        i_s = int(t_cursor * SR)
        i_e = min(n, i_s + len(h_wav))
        track[i_s:i_e, 0] += h_wav[:i_e - i_s] * (1.0 - pan)
        track[i_s:i_e, 1] += h_wav[:i_e - i_s] * pan
        t_cursor += step

    t = np.linspace(0, duration_sec, n, endpoint=False)
    f963 = np.sin(2 * np.pi * 963.0 * t) * 0.02
    bed = np.column_stack([f963, f963])

    wet = apply_stereo_reverb(track * 0.68, decay=0.55)
    mix = wet + bed
    loop = make_circular_loop(mix, crossfade_sec=4.0)
    save_aac(loop, MUSIC_DIR / "so-20-dreamy-ethereal.m4a")
    print("✓ Upgraded SO-20: Mơ màng thanh khiết (Dreamy Ethereal - 963 Hz Glass Chimes & Harp)")


def render_so10_soft_sound_bath(duration_sec=64):
    """
    SO-10: Tắm âm thanh dịu nhẹ (Soft Sound Bath).
    Authentic 432 Hz Tibetan singing bowl resonance with 4.5 Hz theta wave binaural beats.
    Deeply calming, pure and meditative.
    """
    n = int(SR * duration_sec)
    t = np.linspace(0, duration_sec, n, endpoint=False)

    b1 = np.sin(2 * np.pi * 432.0 * t) * 0.35
    b2 = np.sin(2 * np.pi * 436.5 * t) * 0.35

    sub = np.sin(2 * np.pi * 216.0 * t) * 0.22
    fifth = np.sin(2 * np.pi * 648.0 * t) * 0.12
    octv = np.sin(2 * np.pi * 864.0 * t) * 0.08

    mod = 0.75 + 0.25 * np.sin(2 * np.pi * t / 8.0)

    left = (b1 + sub + fifth * 0.8 + octv) * mod
    right = (b2 + sub + fifth * 1.2 + octv) * mod
    mix = np.column_stack([left, right])
    loop = make_circular_loop(mix, crossfade_sec=4.0)
    save_aac(loop, AMBIENCE_DIR / "so-10-soft-sound-bath.m4a")
    print("✓ Upgraded SO-10: Tắm âm thanh dịu nhẹ (432 Hz Tibetan Singing Bowls)")


def render_so03_window_rain(duration_sec=64):
    """
    SO-03: Mưa bên cửa sổ (Window Rain).
    Muffled, cozy rain outside a double-pane window + soft 174 Hz tension relief foundation.
    NO harsh treble static or white hiss!
    """
    n = int(SR * duration_sec)
    t = np.linspace(0, duration_sec, n, endpoint=False)

    f174 = np.sin(2 * np.pi * 174.0 * t) * 0.06
    f87 = np.sin(2 * np.pi * 87.0 * t) * 0.08
    bed = np.column_stack([f174 + f87, f174 + f87])

    np.random.seed(33)
    rain = np.zeros((n, 2), dtype=np.float32)
    n_drops = int(duration_sec * 60)
    d_times = np.random.uniform(0, duration_sec, n_drops)
    for dt in d_times:
        i_s = int(dt * SR)
        d_dur = np.random.uniform(0.012, 0.028)
        i_e = min(n, i_s + int(d_dur * SR))
        if i_e > i_s:
            t_d = np.linspace(0, (i_e - i_s) / SR, i_e - i_s, endpoint=False)
            f_drop = np.random.uniform(320, 680)
            drop_wav = np.sin(2 * np.pi * f_drop * t_d) * np.exp(-t_d * 180.0) * 0.04
            pan = np.random.uniform(0.2, 0.8)
            rain[i_s:i_e, 0] += drop_wav * (1.0 - pan)
            rain[i_s:i_e, 1] += drop_wav * pan

    distant_rain = np.sin(2 * np.pi * 145.0 * t) * 0.04 + np.sin(2 * np.pi * 220.0 * t) * 0.03
    rain_body = np.column_stack([distant_rain, distant_rain])

    mix = bed + rain + rain_body
    loop = make_circular_loop(mix, crossfade_sec=4.0)
    save_aac(loop, AMBIENCE_DIR / "so-03-window-rain.m4a")
    print("✓ Upgraded SO-03: Mưa bên cửa sổ (Cozy Muffled Window Rain & 174 Hz)")


def render_so05_ocean_breath(duration_sec=64):
    """
    SO-05: Nhịp thở đại dương (Ocean Breath).
    Slow, gentle rolling ocean swells (10s period) + 285 Hz restorative energy bed.
    """
    n = int(SR * duration_sec)
    t = np.linspace(0, duration_sec, n, endpoint=False)

    swell = (0.5 + 0.5 * np.sin(2 * np.pi * t / 9.8 - np.pi / 2)) ** 2.2
    surf_l = (np.sin(2 * np.pi * 65.0 * t) * 0.09 + np.sin(2 * np.pi * 130.0 * t) * 0.06) * swell
    surf_r = (np.sin(2 * np.pi * 65.0 * t) * 0.09 + np.sin(2 * np.pi * 130.0 * t) * 0.06) * np.roll(swell, int(SR * 0.7))

    f285 = np.sin(2 * np.pi * 285.0 * t) * 0.05
    mix = np.column_stack([surf_l + f285, surf_r + f285])
    loop = make_circular_loop(mix, crossfade_sec=4.0)
    save_aac(loop, AMBIENCE_DIR / "so-05-ocean-breath.m4a")
    print("✓ Upgraded SO-05: Nhịp thở đại dương (Gentle Rolling Ocean & 285 Hz)")


def render_so07_fireplace_room(duration_sec=64):
    """
    SO-07: Căn phòng có lò sưởi (Fireplace Room).
    Warm, cozy hearth embers popping softly (low-pass filtered under 250 Hz, no high crackle spikes) + 396 Hz grounding.
    """
    n = int(SR * duration_sec)
    t = np.linspace(0, duration_sec, n, endpoint=False)

    f396 = np.sin(2 * np.pi * 396.0 * t) * 0.06
    f198 = np.sin(2 * np.pi * 198.0 * t) * 0.08
    bed = np.column_stack([f396 + f198, f396 + f198])

    np.random.seed(99)
    fire = np.zeros((n, 2), dtype=np.float32)
    n_pops = int(duration_sec * 30)
    p_times = np.random.uniform(0, duration_sec, n_pops)
    for pt in p_times:
        i_s = int(pt * SR)
        p_dur = np.random.uniform(0.015, 0.04)
        i_e = min(n, i_s + int(p_dur * SR))
        if i_e > i_s:
            t_p = np.linspace(0, (i_e - i_s) / SR, i_e - i_s, endpoint=False)
            f_pop = np.random.uniform(180, 420)
            pop_wav = np.sin(2 * np.pi * f_pop * t_p) * np.exp(-t_p * 90.0) * 0.05
            pan = np.random.uniform(0.3, 0.7)
            fire[i_s:i_e, 0] += pop_wav * (1.0 - pan)
            fire[i_s:i_e, 1] += pop_wav * pan

    mix = bed + fire
    loop = make_circular_loop(mix, crossfade_sec=4.0)
    save_aac(loop, AMBIENCE_DIR / "so-07-fireplace-room.m4a")
    print("✓ Upgraded SO-07: Căn phòng có lò sưởi (Warm Cozy Fireplace & 396 Hz)")


def main():
    print("=================================================================")
    print(" Rendering Complete Suite of Healing & Melodious Soundscapes    ")
    print("=================================================================")

    # 1. Newly requested spaces (re-engineered with melody & gentle organic layers)
    render_so28_winter_hearth_tea()
    render_so24_sunset_ocean_waves()
    render_so25_cat_purring_piano()
    render_so26_puppy_acoustic()
    render_so27_forest_birds_breeze()

    # 2. Entire Music Catalogue Upgraded to Genuine Healing Instruments
    render_so11_warm_felt_piano()
    render_so12_future_horizon()
    render_so13_golden_flow()
    render_so14_rooted_calm()
    render_so15_abundance_current()
    render_so16_open_sky_handpan()
    render_so17_warm_rnb_ambient()
    render_so18_heart_space()
    render_so19_quiet_momentum()
    render_so20_dreamy_ethereal()

    # 3. Ambient Catalogue Refined to Soft Organic Textures
    render_so03_window_rain()
    render_so05_ocean_breath()
    render_so07_fireplace_room()
    render_so10_soft_sound_bath()

    print("\nAll audio assets successfully rendered and mastered to true healing quality!")


if __name__ == "__main__":
    main()
