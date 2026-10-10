# -*- coding: utf-8 -*-
"""Generates localized guided audio tracks GA-32, GA-33, GA-34 for ko, ja, fr, zh."""
import asyncio
import subprocess
import tempfile
from pathlib import Path

import edge_tts

ROOT = Path(__file__).resolve().parents[1]
FFMPEG = str(ROOT / "tool_bin" / "ffmpeg.exe")

VOICES = {
    "ko": "ko-KR-SunHiNeural",
    "ja": "ja-JP-NanamiNeural",
    "fr": "fr-FR-VivienneMultilingualNeural",
    "zh": "zh-CN-XiaoxiaoNeural",
}

SCRIPTS = {
    "ga-32-mothers-morning-greeting.m4a": {
        "bg": str(ROOT / "assets/audio/music/so-23-peaceful-tet-spring-lullaby.m4a"),
        "texts": {
            "ko": (
                "아가야, 일어났니? 창밖을 보렴. 봄 햇살이 마당에 따스하게 내려앉았단다. "
                "차도 따뜻하게 우려두었으니 서두르지 말고 천천히 숨을 들이마셔 보렴. "
                "집에서는 언제나 네가 가장 안전하고 사랑받고 있단다. 오늘 하루도 평온하고 다정하게 시작하자꾸나."
            ),
            "ja": (
                "おはよう、もう目が覚めた？ 窓の外を見てごらん、春の柔らかな日差しが庭に差し込んでいるよ。"
                "温かいお茶を淹れておいたから、急がずにゆっくり深呼吸してね。"
                "この家にいるとき、あなたはいつも守られ、愛されているよ。今日も穏やかで優しい一日を始めようね。"
            ),
            "fr": (
                "Bonjour mon enfant, tu es réveillé ? Regarde par la fenêtre, la douce lumière du printemps "
                "baigne déjà la cour. Le thé chaud est prêt sur la table. Ne te presse pas, respire profondément. "
                "Ici à la maison, tu es toujours en sécurité et profondément aimé. Commençons cette nouvelle journée dans la paix."
            ),
            "zh": (
                "孩子，醒了吗？看看窗外，温柔的春光已经洒满小院，桃花也静静开了。"
                "妈妈已经泡好了热茶，不用着急，先轻轻深呼吸。"
                "在家里，你永远被爱包围、永远安全。愿你带着满心安宁，开启这温柔美好的新一天。"
            ),
        },
    },
    "ga-33-gryffindor-winter-sanctuary.m4a": {
        "bg": str(ROOT / "assets/audio/music/so-21-gryffindor-hearth-chimes.m4a"),
        "texts": {
            "ko": (
                "이 고대 탑의 따뜻한 방에 오신 것을 환영합니다. 창밖에는 겨울 눈꽃이 조용히 내리고, "
                "벽난로의 불꽃이 포근한 온기로 당신을 감싸줍니다. 양모 담요를 어깨에 두르고 천천히 숨을 내쉬어 보세요. "
                "이 마법 같은 안식처에서 당신은 온전히 안전하고 평화롭습니다."
            ),
            "ja": (
                "古い塔の温かい個室へようこそ。窓の外では冬の雪が静かに舞い、"
                "暖炉の炎が優しいぬくもりであなたを包み込んでいます。毛布にくるまって、ゆっくりと息を吐き出しましょう。"
                "この魔法のような聖域で、あなたは完全に守られ、安らいでいます。"
            ),
            "fr": (
                "Bienvenue dans cette chambre chaleureuse au sommet de la tour. Dehors, la neige d'hiver tombe en silence, "
                "tandis que le feu de la cheminée vous enveloppe d'une douce lueur dorée. Blottissez-vous sous le plaid "
                "et expirez lentement. Dans ce sanctuaire magique, vous êtes profondément en paix."
            ),
            "zh": (
                "欢迎来到这座古塔里温暖的私人房间。窗外冬雪静静飘落，壁炉里的火光发出柔和的噼啪声，"
                "将温暖裹在你的身旁。裹紧柔软的羊毛毯，缓缓呼出一口气。在这片充满魔法的静谧天地里，你无比安全、无比平静。"
            ),
        },
    },
    "ga-34-autumn-thanksgiving-gratitude.m4a": {
        "bg": str(ROOT / "assets/audio/music/so-22-autumn-harvest-acoustic.m4a"),
        "texts": {
            "ko": (
                "황금빛 가을 오후의 아늑한 식탁에 앉아 보세요. 갓 구운 파이의 달콤한 향기와 따뜻한 차 한 잔, "
                "그리고 창밖의 붉은 단풍숲이 마음을 채워줍니다. 숨을 깊이 들이마시며 지금 이 순간 당신의 삶에 머무는 "
                "작은 축복들과 풍요로움에 조용히 감사를 보내보세요."
            ),
            "ja": (
                "黄金色の秋の午後、心地よいテーブルに座りましょう。焼きたてのパイの甘い香りと温かいお茶、"
                "そして窓の外に広がる紅葉の森が心を満たしてくれます。深く息を吸い込み、"
                "今ここにある小さな恵みと豊かさに、静かな感謝を送りましょう。"
            ),
            "fr": (
                "Installez-vous dans ce coin chaleureux par un doux après-midi d'automne. Le parfum d'une tarte tout juste dorée, "
                "une tasse de thé fumante et la forêt aux feuilles ambrées apaisent votre esprit. Inspirez profondément "
                "et ressentez une douce gratitude pour l'abondance qui vous entoure."
            ),
            "zh": (
                "在这个金色的秋日午后，静静坐在温馨的餐桌旁。刚出炉的果派散发着甜香，热茶升起暖雾，"
                "窗外是漫山红叶的静美森林。深深吸气，感受此刻生命中的丰盛与温暖，在心底轻轻说一声感恩。"
            ),
        },
    },
}


async def render_one(lang: str, filename: str, text: str, bg_path: str):
    out_dir = ROOT / "assets" / "audio" / "guided" / lang
    out_dir.mkdir(parents=True, exist_ok=True)
    out_path = out_dir / filename

    voice = VOICES[lang]
    with tempfile.NamedTemporaryFile(suffix=".mp3", delete=False) as tmp:
        tts_mp3 = tmp.name

    communicate = edge_tts.Communicate(text=text, voice=voice, rate="-12%", pitch="-2Hz")
    await communicate.save(tts_mp3)

    cmd = [
        FFMPEG,
        "-y",
        "-i",
        tts_mp3,
        "-i",
        bg_path,
        "-filter_complex",
        "[0:a]adelay=800|800,volume=1.55[v];[1:a]volume=0.22,afade=t=in:st=0:d=1.5,afade=t=out:st=23:d=3[b];[v][b]amix=inputs=2:duration=first:dropout_transition=2[out]",
        "-map",
        "[out]",
        "-c:a",
        "aac",
        "-b:a",
        "48k",
        "-ar",
        "24000",
        str(out_path),
    ]
    subprocess.run(cmd, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    Path(tts_mp3).unlink(missing_ok=True)
    print(f"Generated {out_path.relative_to(ROOT)} ({out_path.stat().st_size // 1024} KB)")


async def main():
    for filename, cfg in SCRIPTS.items():
        bg = cfg["bg"]
        for lang, text in cfg["texts"].items():
            await render_one(lang, filename, text, bg)


if __name__ == "__main__":
    asyncio.run(main())
