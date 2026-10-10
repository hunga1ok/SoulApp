# -*- coding: utf-8 -*-
"""Populates ko, ja, fr, zh translations in assets/content/*.json."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONTENT_DIR = ROOT / "assets" / "content"

INTENTIONS_TRANS = {
    "FIND_PEACE": {
        "ko": "마음의 평온 되찾기",
        "ja": "心の安らぎを取り戻す",
        "fr": "Retrouver la paix intérieure",
        "zh": "寻回内心平静",
    },
    "NURTURE_GRATITUDE": {
        "ko": "감사의 마음 가꾸기",
        "ja": "感謝の心を育む",
        "fr": "Cultiver la gratitude",
        "zh": "滋养感恩之心",
    },
    "BUILD_FUTURE_SELF": {
        "ko": "미래의 나 만들어가기",
        "ja": "理想の未来の自分を築く",
        "fr": "Construire mon futur moi",
        "zh": "塑造未来的自己",
    },
    "CARE_FOR_RELATIONSHIPS": {
        "ko": "소중한 관계 돌보기",
        "ja": "大切な人間関係を育む",
        "fr": "Prendre soin de mes relations",
        "zh": "呵护珍贵的关系",
    },
}

CZ_CATEGORIES_TRANS = {
    "cozy_indoor": {
        "title": {
            "ko": "아늑한 실내 안식처",
            "ja": "心地よい部屋の片隅",
            "fr": "Intérieur douillet",
            "zh": "温馨室内角落",
        },
        "subtitle": {
            "ko": "Cozy Indoor — 작은 방 안의 따스함과 고요함",
            "ja": "Cozy Indoor — 小さな部屋に満ちる温もりと静けさ",
            "fr": "Cozy Indoor — Chaleur et quiétude dans votre petit cocon",
            "zh": "Cozy Indoor — 小小房间里的温暖与静谧",
        },
        "description": {
            "ko": "따뜻한 담요 속에 몸을 말고 창밖의 빗소리를 듣거나, 노란 조명 아래 조용히 책을 읽을 수 있는 포근한 실내 공간입니다.",
            "ja": "温かい毛布にくるまって窓辺の雨音に耳を傾けたり、優しい灯りの下で静かに読書を楽しめる心地よい室内空間です。",
            "fr": "Des refuges intérieurs douillets où vous blottir sous un plaid chaud, écouter la pluie sur la vitre ou lire à la lueur dorée d'une lampe.",
            "zh": "温柔舒适的室内角落，你可以蜷缩在温暖的毛毯里，倾听窗外的雨声，或在柔和灯光下静静阅读。",
        },
    },
    "nature_escape": {
        "title": {
            "ko": "자연 속 도피처",
            "ja": "自然へのエスケープ",
            "fr": "Évasion dans la nature",
            "zh": "自然逃离之地",
        },
        "subtitle": {
            "ko": "Nature Escape — 언덕과 호수, 고요한 숲속의 깊은 호흡",
            "ja": "Nature Escape — 丘や湖、静かな森の中で深呼吸を",
            "fr": "Nature Escape — Respirez profondément entre collines, lacs et forêts",
            "zh": "Nature Escape — 在山丘、湖泊与静谧森林间深呼吸",
        },
        "description": {
            "ko": "별이 쏟아지는 야생화 언덕, 달빛이 비치는 잔잔한 호수, 안개 낀 소나무 숲속에 숨겨진 작은 오두막을 만나보세요.",
            "ja": "星空の下の野花の丘、月明かりを映す静かな湖、霧の松林に佇む小さな木のキャビン。",
            "fr": "Des collines fleuries sous les étoiles, des lacs paisibles au clair de lune et de petites cabanes nichées dans la brume des pins.",
            "zh": "星空下的野花山丘、月光映照的平静湖面，以及隐匿在薄雾松林中的小小木屋。",
        },
    },
    "little_companions": {
        "title": {
            "ko": "작은 친구들과의 평온",
            "ja": "小さな仲間との安らぎ",
            "fr": "Petits compagnons",
            "zh": "与小生命相伴的宁静",
        },
        "subtitle": {
            "ko": "Little Companions — 말없이도 전해지는 다정한 온기",
            "ja": "Little Companions — 言葉はいらない、優しいぬくもり",
            "fr": "Little Companions — Une présence douce et chaleureuse sans mots",
            "zh": "Little Companions — 无需言语的温柔陪伴",
        },
        "description": {
            "ko": "창가에서 고르릉거리는 고양이, 풀언덕에 나란히 누운 강아지, 사랑하는 사람과 어깨를 기대는 평화로운 순간입니다.",
            "ja": "窓辺で丸くなる猫、草の丘で寄り添う犬、大切な人と肩を寄せ合う穏やかなひととき。",
            "fr": "Un chat qui ronronne sur le rebord de la fenêtre, un chien fidèle à vos côtés sur la colline ou une épaule aimante sur laquelle s'appuyer.",
            "zh": "窗台上蜷缩酣睡的猫咪、草坡上并肩依偎的小狗，或是与挚爱轻轻靠肩的安心时刻。",
        },
    },
    "dreamy_moments": {
        "title": {
            "ko": "간직하고 싶은 꿈같은 순간",
            "ja": "心に留めたい夢のような瞬間",
            "fr": "Instants de rêve",
            "zh": "想要珍藏的梦幻时刻",
        },
        "subtitle": {
            "ko": "Dreamy Moments — 별빛과 비, 구름 아래의 시적인 휴식",
            "ja": "Dreamy Moments — 星明かりや雨、雲の下での詩的なひととき",
            "fr": "Dreamy Moments — Pauses poétiques sous les étoiles, la pluie et les nuages",
            "zh": "Dreamy Moments — 星光、微雨与云海间的诗意停驻",
        },
        "description": {
            "ko": "조용한 옥상에서 바라보는 은하수, 비 오는 날 카페 창가의 커피 한 잔, 푸른 들판을 스쳐 지나가는 평온한 기차 여행입니다.",
            "ja": "静かな屋上からの星空眺め、雨のカフェの窓辺のコーヒー、緑の野原を駆け抜ける穏やかな列車の旅。",
            "fr": "Contempler les étoiles depuis un toit paisible, savourer un café près d'une vitre sous la pluie ou regarder les prairies défiler depuis un train.",
            "zh": "在静谧屋顶仰望璀璨银河、雨天咖啡馆窗边的一杯热咖啡，或是乘着安静列车掠过青翠原野。",
        },
    },
}

CZ_SCENES_TRANS = {
    "cz_01": {
        "title": {"ko": "게으른 아침", "ja": "まどろみの朝", "fr": "Matin paresseux", "zh": "慵懒清晨"},
        "affirmation": {
            "ko": "오늘 당신은 아주 천천히 깨어나 자신에게 다정해질 자격이 있습니다.",
            "ja": "今日はゆっくりと目覚め、自分自身に優しくしていい日です。",
            "fr": "Aujourd'hui, vous avez le droit de vous réveiller lentement et avec douceur.",
            "zh": "今天，你可以慢慢醒来，温柔地对待自己。",
        },
    },
    "cz_02": {
        "title": {"ko": "책들의 방", "ja": "本のある部屋", "fr": "La chambre des livres", "zh": "书香房间"},
        "affirmation": {
            "ko": "조용한 책장들과 별이 빛나는 밤하늘 사이에서 당신의 마음은 안전한 안식처를 찾습니다.",
            "ja": "静かなページと星空の間で、あなたの心は安全な隠れ家を見つけます。",
            "fr": "Entre les pages silencieuses et le ciel étoilé, votre esprit trouve un refuge sûr.",
            "zh": "在静谧书页与璀璨星空之间，你的心找到了安全的港湾。",
        },
    },
    "cz_03": {
        "title": {"ko": "가장 포근한 소파", "ja": "一番やわらかなソファ", "fr": "Le canapé le plus doux", "zh": "最柔软的沙发"},
        "affirmation": {
            "ko": "밖에는 비가 내리지만, 이곳에서 당신은 충분히 따뜻하고 평온합니다.",
            "ja": "外は雨が降っていても、ここでは温もりと安らぎに包まれています。",
            "fr": "Laissez la pluie tomber dehors ; ici, vous êtes au chaud et en paix.",
            "zh": "任凭窗外细雨飘落，此刻在这里的你温暖、安稳而平静。",
        },
    },
    "cz_04": {
        "title": {"ko": "느릿한 부엌", "ja": "ゆっくり流れるキッチン", "fr": "Cuisine au rythme lent", "zh": "慢时光厨房"},
        "affirmation": {
            "ko": "행복은 때로 갓 구운 따뜻한 빵 내음과 서두르지 않는 리듬 속에 있습니다.",
            "ja": "幸せとは、焼きたてのパンの香りとゆったりとしたリズムのようにシンプルなものです。",
            "fr": "Le bonheur est parfois aussi simple que du pain chaud et un rythme sans hâte.",
            "zh": "幸福有时很简单，不过是一缕温热的面包香与不疾不徐的生活节律。",
        },
    },
    "cz_05": {
        "title": {"ko": "어디도 가지 않아도 되는 비 오는 날", "ja": "どこへも行かなくていい雨の日", "fr": "Fenêtre sous la pluie", "zh": "无需远行的雨天"},
        "affirmation": {
            "ko": "오늘 어디로든 서둘러 갈 필요가 없습니다. 그저 쉬어가는 것만으로도 충분합니다.",
            "ja": "今日はどこへも急ぐ必要はありません。ただ休むだけで十分なのです。",
            "fr": "Vous n'avez besoin de courir nulle part aujourd'hui. Se reposer suffit amplement.",
            "zh": "今天你不必匆忙赶往任何地方，安然休息本身就是一种圆满。",
        },
    },
    "cz_06": {
        "title": {"ko": "비밀스러운 다락방", "ja": "秘密の屋根裏部屋", "fr": "Le petit grenier", "zh": "秘密小阁楼"},
        "affirmation": {
            "ko": "모든 소음이 멀리 물러나는, 오직 당신만을 위한 조용하고 작은 세계입니다.",
            "ja": "すべての喧騒を遠くに置いた、あなただけの静かで小さな世界です。",
            "fr": "Un petit monde paisible bien à vous, loin de tout le bruit extérieur.",
            "zh": "属于你自己的小小世界，所有的喧嚣都被轻轻挡在身后。",
        },
    },
    "cz_07": {
        "title": {"ko": "벽난로 옆의 겨울", "ja": "暖炉のそばの冬", "fr": "Au coin du feu d'hiver", "zh": "冬日壁炉旁"},
        "affirmation": {
            "ko": "부드러운 불빛은 당신의 내면에 언제나 따뜻한 온기가 살아 있음을 일깨워 줍니다.",
            "ja": "優しい炎の灯りは、あなたの中にいつも温もりがあることを教えてくれます。",
            "fr": "La douce lueur du feu vous rappelle que la chaleur vit toujours en vous.",
            "zh": "跃动的温暖火光提醒着你，内心深处始终有一处庇护的暖意。",
        },
    },
    "cz_08": {
        "title": {"ko": "달빛 아래의 목욕", "ja": "月明かりのバスタイム", "fr": "Bain de minuit", "zh": "月光下的沐浴"},
        "affirmation": {
            "ko": "따뜻한 물결이 긴 하루의 피로와 무게를 부드럽게 씻어내도록 맡겨 보세요.",
            "ja": "温かいお湯が、長い一日の疲れを優しく洗い流してくれますように。",
            "fr": "Laissez l'eau chaude emporter doucement toute la fatigue de la journée.",
            "zh": "让温热的水流轻轻洗去这一整天的疲惫与重量。",
        },
    },
    "cz_09": {
        "title": {"ko": "꽃언덕 위의 작은 집", "ja": "花の丘の小さな家", "fr": "La colline aux fleurs", "zh": "花丘上的小木屋"},
        "affirmation": {
            "ko": "드넓은 별빛 아래, 당신의 마음은 자신만의 속도로 자유롭게 꽃피울 수 있습니다.",
            "ja": "広大な星空の下、あなたの心は自分のペースで自由に花開くことができます。",
            "fr": "Sous le vaste ciel étoilé, votre cœur est libre de s'épanouir à son propre rythme.",
            "zh": "在浩瀚星空下，你的心可以按照自己的节奏自由绽放。",
        },
    },
    "cz_10": {
        "title": {"ko": "누워서 구름 바라보기", "ja": "雲を眺める午後", "fr": "Contempler les nuages", "zh": "躺看云卷云舒"},
        "affirmation": {
            "ko": "하늘을 흐르는 흰 구름처럼 당신의 생각들도 가볍게 흘러가도록 두세요.",
            "ja": "空を流れる白い雲のように、思考も軽やかに流れていくままにしましょう。",
            "fr": "Laissez vos pensées glisser aussi légèrement que les nuages blancs dans le ciel.",
            "zh": "让思绪像天边的白云一样，自然而然地轻轻飘过。",
        },
    },
    "cz_11": {
        "title": {"ko": "호숫가의 오두막", "ja": "湖畔のキャビン", "fr": "La cabane au bord du lac", "zh": "湖畔木屋"},
        "affirmation": {
            "ko": "마음이 밤호수처럼 고요해질 때, 평화로운 달빛이 저절로 선명하게 비춰집니다.",
            "ja": "心が夜の湖のように静まるとき、穏やかな月明かりが自然と映し出されます。",
            "fr": "Quand votre cœur s'apaise comme un lac nocturne, la douce lune se révèle d'elle-même.",
            "zh": "当心如夜湖般澄澈平静，宁静的月光便会自然浮现。",
        },
    },
    "cz_12": {
        "title": {"ko": "오래된 나무 아래", "ja": "大きな古木の下で", "fr": "Sous le vieil arbre", "zh": "老树浓荫下"},
        "affirmation": {
            "ko": "든든한 나무 그늘 아래에서 이제 어깨의 긴장을 천천히 내려놓아도 좋습니다.",
            "ja": "頼もしい木陰の下で、肩の力をすっと抜いて休んでいいのです。",
            "fr": "Sous l'ombre protectrice du vieil arbre, vous pouvez enfin relâcher vos épaules.",
            "zh": "在古老大树稳稳的树荫下，你可以安心卸下双肩的紧绷。",
        },
    },
    "cz_13": {
        "title": {"ko": "바닷가의 작은 은신처", "ja": "海辺の隠れ家", "fr": "Refuge en bord de mer", "zh": "海畔静谧一隅"},
        "affirmation": {
            "ko": "바다의 드넓은 숨결을 들이마시고, 더 이상 짊어질 필요 없는 것들을 내쉬어 보세요.",
            "ja": "海の広大な息吹を吸い込み、もう抱えなくていいものを吐き出しましょう。",
            "fr": "Inspirez l'immensité de l'océan, expirez ce que vous n'avez plus besoin de porter.",
            "zh": "吸进大海的辽阔气息，呼出那些不再属于你的负担。",
        },
    },
    "cz_14": {
        "title": {"ko": "비밀의 화원", "ja": "秘密の花園", "fr": "Le jardin secret", "zh": "秘密花园"},
        "affirmation": {
            "ko": "당신의 영혼 속 비밀 정원에는 지금도 고요하고 아름다운 꽃들이 피어나고 있습니다.",
            "ja": "あなたの心の中の秘密の庭では、今も静かに優しい美しさが花開いています。",
            "fr": "Le jardin secret de votre âme continue de fleurir doucement en silence.",
            "zh": "你灵魂深处的秘密花园，正悄然盛开着温柔而美好的花朵。",
        },
    },
    "cz_15": {
        "title": {"ko": "숲속의 은신처", "ja": "森の隠れ家", "fr": "Cachette dans la forêt", "zh": "森林隐居处"},
        "affirmation": {
            "ko": "고요한 숲의 깊은 품 안에서 당신은 자신의 다정한 목소리를 다시 듣게 됩니다.",
            "ja": "静かな森の奥深くで、あなた自身の優しい声がまた聞こえてきます。",
            "fr": "Dans le calme profond de la forêt, vous réapprendrez à entendre votre propre voix douce.",
            "zh": "在静谧深林的怀抱中，你能重新听见自己内心温柔的声音。",
        },
    },
    "cz_16": {
        "title": {"ko": "고양이와 함께한 오후", "ja": "猫と過ごす午後", "fr": "Un après-midi avec le chat", "zh": "与猫相伴的午后"},
        "affirmation": {
            "ko": "저물어 가는 노을빛 옆에 가만히 앉아 있는 것만으로도 평온은 이미 당신 곁에 있습니다.",
            "ja": "夕暮れの光のそばに静かに座るだけで、安らぎはもうあなたの隣にあります。",
            "fr": "Assis paisiblement dans la lumière du soir, la paix est déjà tout près de vous.",
            "zh": "只需在暮色余晖旁静静坐着，宁静便已经在你身边。",
        },
    },
    "cz_17": {
        "title": {"ko": "네 발 달린 친구", "ja": "四つ足の親友", "fr": "L'ami fidèle", "zh": "四足挚友"},
        "affirmation": {
            "ko": "어떤 동행은 말 한마디 없이도 밤하늘 전체를 따뜻하게 데워 줍니다.",
            "ja": "言葉がなくても、夜空全体を温めてくれる寄り添いがあります。",
            "fr": "Certaines présences n'ont besoin d'aucun mot pour réchauffer tout le ciel nocturne.",
            "zh": "有些陪伴无需言语，却足以温暖整片夜空。",
        },
    },
    "cz_18": {
        "title": {"ko": "오후의 낮잠", "ja": "午後のうたた寝", "fr": "Sieste d'après-midi", "zh": "午后小憩"},
        "affirmation": {
            "ko": "따스한 햇살 속에 두 눈을 감으세요. 바깥세상은 잠시 당신을 기다려 줄 수 있습니다.",
            "ja": "柔らかな日差しの中で目を閉じましょう。外の世界は少し待っていてくれます。",
            "fr": "Fermez les yeux dans la douce lumière ; le monde extérieur peut attendre un instant.",
            "zh": "在温暖阳光下轻轻闭上双眼，外面的世界可以再等你一会儿。",
        },
    },
    "cz_19": {
        "title": {"ko": "두 친구의 작은 피크닉", "ja": "ふたりの小さなピクニック", "fr": "Petit pique-nique", "zh": "两个好朋友的野餐"},
        "affirmation": {
            "ko": "가장 순수한 기쁨은 지금 이 자리에 온전히 머무는 순간 속에 살아 있습니다.",
            "ja": "最もシンプルな喜びは、今この瞬間に心を満たして存在する中にあります。",
            "fr": "La joie la plus simple réside dans l'instant où vous êtes pleinement présent ici.",
            "zh": "最纯粹的喜悦，就藏在你全然安住于当下的这一刻。",
        },
    },
    "cz_20": {
        "title": {"ko": "함께여서 충분한 집", "ja": "一緒にいるだけで十分", "fr": "Ensemble à la maison", "zh": "相伴便是圆满"},
        "affirmation": {
            "ko": "평온은 먼 곳이 아니라, 서로의 곁에서 느끼는 고요한 안전함입니다.",
            "ja": "安らぎとは遠い場所ではなく、共にいることの静かな安心感です。",
            "fr": "La paix n'est pas un lieu lointain, mais la douce sécurité d'être ensemble.",
            "zh": "宁静并非遥不可及的远方，而是彼此依偎时那份踏实的心安。",
        },
    },
    "cz_21": {
        "title": {"ko": "지붕 위의 별밤", "ja": "星空のルーフトップ", "fr": "Toit sous les étoiles", "zh": "屋顶观星之夜"},
        "affirmation": {
            "ko": "끝없는 우주 아래에서 오늘의 모든 걱정은 아주 작고 가벼워집니다.",
            "ja": "果てしない宇宙の下では、今日の悩みも小さく優しく溶けていきます。",
            "fr": "Sous le cosmos infini, les soucis d'aujourd'hui deviennent tout petits.",
            "zh": "在浩瀚无垠的宇宙之下，今天所有的烦恼都变得渺小而轻盈。",
        },
    },
    "cz_22": {
        "title": {"ko": "해 질 녘 발코니", "ja": "夕暮れのバルコニー", "fr": "Balcon au coucher du soleil", "zh": "日落阳台"},
        "affirmation": {
            "ko": "부드러운 황혼이 하루를 닫으며, 고요한 숨결 하나하나를 소중히 여기라고 속삭입니다.",
            "ja": "優しい夕暮れが一日を閉じ、静かな呼吸のひとつひとつを慈しむよう囁きます。",
            "fr": "Le doux crépuscule clôt la journée et vous invite à chérir chaque souffle.",
            "zh": "温柔的暮色轻轻合上一天，提醒你珍视每一次平静的呼吸。",
        },
    },
    "cz_23": {
        "title": {"ko": "비 오는 날의 커피", "ja": "雨の日のコーヒー", "fr": "Café sous la pluie", "zh": "雨日咖啡馆"},
        "affirmation": {
            "ko": "따뜻한 커피 한 잔과 함께 창밖의 빗줄기를 바라보며 마음을 가만히 가라앉혀 보세요.",
            "ja": "温かいカップを手に雨を眺め、心を静かに落ち着かせましょう。",
            "fr": "Asseyez-vous avec une tasse chaude, regardez la pluie tomber et apaisez votre cœur.",
            "zh": "伴着一杯温热咖啡静坐窗前，看细雨落下，让心慢慢沉淀。",
        },
    },
    "cz_24": {
        "title": {"ko": "평온한 기차 여행", "ja": "静かな列車の旅", "fr": "Le train paisible", "zh": "宁静列车之旅"},
        "affirmation": {
            "ko": "삶은 긴 여정입니다. 때로는 그저 창가에 기대어 흘러가는 풍경을 바라보기만 해도 좋습니다.",
            "ja": "人生は長い旅。ときには窓に頭をもたれ、流れる景色を眺めるだけでいいのです。",
            "fr": "La vie est un long voyage — parfois, il suffit de poser sa tête et d'admirer le paysage.",
            "zh": "人生是一场漫长的旅途，有时你只需轻轻靠窗，静看风景流转。",
        },
    },
    "cz_25": {
        "title": {"ko": "구름 위의 작은 집", "ja": "雲の上の小さな家", "fr": "Une maison au-dessus des nuages", "zh": "云端之上的小屋"},
        "affirmation": {
            "ko": "두터운 구름층 위에는 언제나 맑고 부드러운 새벽하늘이 당신을 기다리고 있습니다.",
            "ja": "どれほど厚い雲の上にも、いつも澄んだ優しい夜明けの空が待っています。",
            "fr": "Au-dessus de chaque couche de nuages, une aube claire et douce vous attend toujours.",
            "zh": "无论云层多厚，云端之上总有澄澈而温柔的黎明在等待着你。",
        },
    },
    "cz_26": {
        "title": {
            "ko": "그리핀도르 개인실의 크리스마스",
            "ja": "グリフィンドール個室のクリスマス",
            "fr": "Noël dans une chambre privée de Gryffondor",
            "zh": "格兰芬多私人房间的圣诞夜",
        },
        "affirmation": {
            "ko": "이 따뜻한 고대 탑의 안식처 안에서, 평온과 소속감의 마법이 오직 당신만을 포근히 감싸줍니다.",
            "ja": "この温かい塔の聖域で、安らぎと安心の魔法があなただけを優しく包み込みます。",
            "fr": "Dans ce sanctuaire chaleureux de la tour, la magie de la paix vous enveloppe tout entier.",
            "zh": "在这座温暖的古塔房间里，宁静与归属的魔法只为你一人温柔环绕。",
        },
    },
    "cz_27": {
        "title": {
            "ko": "감사로 물든 가을 오후",
            "ja": "感謝に満ちた秋の午後",
            "fr": "Après-midi d'automne et de gratitude",
            "zh": "感恩的秋日午后",
        },
        "affirmation": {
            "ko": "구운 파이의 온기와 황금빛 가을 햇살 속에서 당신의 마음은 고요한 감사와 풍요로움에 머뭅니다.",
            "ja": "焼きたてのパイの温もりと黄金色の秋の光の中、心は静かな感謝と豊かさに満たされます。",
            "fr": "Parmi le parfum de tarte chaude et la lumière dorée d'automne, votre cœur repose dans la gratitude.",
            "zh": "在烘焙果派的暖香与金色秋光里，你的心安住于宁静的感恩与丰盛之中。",
        },
    },
    "cz_28": {
        "title": {
            "ko": "평화로운 설날 아침",
            "ja": "穏やかなテト（旧正月）の朝",
            "fr": "Un matin de Têt paisible",
            "zh": "宁静的新春清晨",
        },
        "affirmation": {
            "ko": "다정하고 친숙하며 평화로운 새로운 시작이 바로 당신의 집 안에서 꽃피어나고 있습니다.",
            "ja": "優しく馴染み深い、穏やかな新しい始まりが、今あなたの家で花開いています。",
            "fr": "Un nouveau départ doux, familier et paisible s'épanouit ici même chez vous.",
            "zh": "一个温柔、熟悉而宁静的崭新开始，正在你的家中悄然绽放。",
        },
    },
}

AUDIO_TITLES_TRANS = {
    "SO-03": {"ko": "창가의 빗소리", "ja": "窓辺の雨音", "fr": "Pluie sur la fenêtre", "zh": "窗畔细雨"},
    "SO-05": {"ko": "바다의 숨결", "ja": "海の吐息", "fr": "Souffle de l'océan", "zh": "海洋呼吸"},
    "SO-07": {"ko": "벽난로가 있는 방", "ja": "暖炉のある部屋", "fr": "Au coin de la cheminée", "zh": "壁炉暖室"},
    "SO-09": {"ko": "브라운 노이즈", "ja": "ブラウンノイズ", "fr": "Bruit brun apaisant", "zh": "柔和棕噪音"},
    "SO-10": {"ko": "부드러운 사운드 배스", "ja": "優しいサウンドバス", "fr": "Bain sonore délicat", "zh": "轻柔音疗浴"},
    "SO-11": {"ko": "따스한 펠트 피아노", "ja": "温かなフェルトピアノ", "fr": "Piano feutré chaleureux", "zh": "温暖毡音钢琴"},
    "SO-12": {"ko": "미래의 지평선", "ja": "未来の地平線", "fr": "Horizon futur", "zh": "未来地平线"},
    "SO-13": {"ko": "황금빛 흐름", "ja": "黄金のフロー", "fr": "Flux doré", "zh": "金色流光"},
    "SO-14": {"ko": "단단한 평온", "ja": "揺るぎない静けさ", "fr": "Calme enraciné", "zh": "笃定宁静"},
    "SO-15": {"ko": "풍요의 물결", "ja": "豊かさの流れ", "fr": "Courant d'abondance", "zh": "丰盛之流"},
    "SO-16": {"ko": "열린 하늘 핸드팬", "ja": "広い空のハンドパン", "fr": "Handpan à ciel ouvert", "zh": "旷野手碟"},
    "SO-17": {"ko": "따뜻한 R&B 앰비언트", "ja": "温かいR&Bアンビエント", "fr": "Ambiance R&B chaleureuse", "zh": "温暖 R&B 氛围"},
    "SO-18": {"ko": "마음의 공간", "ja": "ハートの空間", "fr": "Espace du cœur", "zh": "心灵空间"},
    "SO-19": {"ko": "고요한 원동력", "ja": "静かな推進力", "fr": "Élan silencieux", "zh": "静谧动力"},
    "SO-20": {"ko": "몽환적인 에테르", "ja": "夢見心地のエーテル", "fr": "Éther onirique", "zh": "梦幻空灵"},
    "SO-21": {"ko": "고대 탑의 벽난로 & 겨울 종소리", "ja": "塔の暖炉と冬のチャイム", "fr": "Foyer de la tour & carillons d'hiver", "zh": "古塔壁炉与冬夜风铃"},
    "SO-22": {"ko": "감사의 가을 어쿠스틱", "ja": "実りの秋のアコースティック", "fr": "Acoustique d'automne reconnaissant", "zh": "秋日感恩原声"},
    "SO-23": {"ko": "평화로운 설날 아침 선율", "ja": "穏やかな春の朝の調べ", "fr": "Mélodie paisible d'un matin de printemps", "zh": "宁静新春晨曲"},
    "GA-01": {"ko": "1분 리셋 명상", "ja": "1分間リセット", "fr": "Réinitialisation d'une minute", "zh": "1 分钟身心重置"},
    "GA-02": {"ko": "아침을 여는 현존", "ja": "朝の目覚め", "fr": "Éveil du matin", "zh": "晨间觉知"},
    "GA-03": {"ko": "아침 감사 명상", "ja": "朝の感謝", "fr": "Gratitude du matin", "zh": "晨间感恩"},
    "GA-04": {"ko": "좋은 것들 알아차리기", "ja": "良きものに気づく", "fr": "Remarquer ce qui est bon", "zh": "觉察生活中的美好"},
    "GA-05": {"ko": "미래의 나와 만나기", "ja": "未来の自分に出会う", "fr": "Rencontrer votre futur moi", "zh": "遇见未来的自己"},
    "GA-06": {"ko": "나의 이상적인 하루", "ja": "理想の一日", "fr": "Votre journée idéale", "zh": "你理想中的一天"},
    "GA-07": {"ko": "고요한 자신감", "ja": "静かな自信", "fr": "Confiance sereine", "zh": "沉静自信"},
    "GA-08": {"ko": "다정한 자기 사랑", "ja": "優しいセルフラブ", "fr": "Douce bienveillance envers soi", "zh": "温柔自爱"},
    "GA-09": {"ko": "저녁의 내려놓음", "ja": "夜の手放し", "fr": "Relâchement du soir", "zh": "晚间释怀"},
    "GA-10": {"ko": "잠들기 전 감사", "ja": "眠りにつく前の感謝", "fr": "Gratitude avant le sommeil", "zh": "睡前感恩"},
    "GA-18": {"ko": "미래로 걸어 들어가기", "ja": "未来へ踏み出す", "fr": "Entrer dans votre avenir", "zh": "步入你的未来"},
    "GA-21": {"ko": "나의 재정적 미래", "ja": "私の豊かな未来", "fr": "Mon avenir financier", "zh": "我的丰盛财务未来"},
    "GA-23": {"ko": "건강한 사랑에 마음 열기", "ja": "健やかな愛に心を開く", "fr": "S'ouvrir à un amour sain", "zh": "敞开心扉迎接健康的爱"},
    "GA-25": {"ko": "미래의 커리어 자아", "ja": "未来のキャリアの自分", "fr": "Mon futur professionnel", "zh": "未来的理想职业自我"},
    "GA-27": {"ko": "내가 아끼고 돌보는 몸", "ja": "大切に育む私の身体", "fr": "Un corps dont je prends soin", "zh": "我温柔呵护的身体"},
    "GA-28": {"ko": "미래의 집으로 돌아오기", "ja": "未来の我が家へ帰る", "fr": "Rentrer dans votre maison future", "zh": "回到未来的家"},
    "GA-29": {"ko": "경이로움이 가득한 삶", "ja": "驚きと感動に満ちた人生", "fr": "Une vie pleine d'émerveillement", "zh": "充满奇迹与美好的生活"},
    "GA-30": {"ko": "우리 사이의 따뜻한 집", "ja": "私たちの間の温かい家", "fr": "Un foyer entre nous", "zh": "我们之间的温暖家园"},
    "GA-31": {"ko": "나 자신에게로 돌아오기", "ja": "自分自身に還る", "fr": "Revenir à soi-même", "zh": "回归内在自我"},
    "GA-32": {"ko": "아침을 깨우는 어머니의 다정한 인사", "ja": "朝を包む母の優しい呼びかけ", "fr": "Le doux bonjour d'une mère au matin", "zh": "清晨母亲温柔的唤醒问候"},
    "GA-33": {"ko": "고대 탑 안식처의 크리스마스 밤", "ja": "古い塔の聖域で過ごすクリスマスの夜", "fr": "Nuit de Noël dans le sanctuaire de la tour", "zh": "古塔避风港里的温暖圣诞夜"},
    "GA-34": {"ko": "감사와 풍요가 머무는 가을 저녁", "ja": "感謝と豊かさに満ちた秋の宵", "fr": "Soirée d'automne de gratitude", "zh": "感恩与丰盛的秋日傍晚"},
}

DECKS_TRANS = {
    "healing": {
        "title": {"ko": "푸른 바다", "ja": "青い海", "fr": "Océan Bleu", "zh": "蔚蓝海洋"},
        "subtitle": {"ko": "영혼의 치유", "ja": "魂の癒やし", "fr": "Guérison de l'âme", "zh": "心灵疗愈"},
        "description": {
            "ko": "내면의 고요함과 자기 연민을 기르는 50가지 다정한 메시지.",
            "ja": "静けさと自己への慈しみを育む50の優しいメッセージ。",
            "fr": "50 messages doux cultivant le calme et la bienveillance envers soi.",
            "zh": "50 条温柔寄语，滋养内心的宁静与自我关怀。",
        },
    },
    "career": {
        "title": {"ko": "빛나는 별길", "ja": "輝く星の道", "fr": "Voie Étoilée", "zh": "星光旅途"},
        "subtitle": {"ko": "커리어 & 목적", "ja": "キャリアと目的", "fr": "Carrière & Mission", "zh": "事业与使命"},
        "description": {
            "ko": "명료함, 용기, 의미 있는 성장을 일깨우는 50가지 영감의 메시지.",
            "ja": "明晰さ、勇気、意味のある成長を導く50のインスピレーション。",
            "fr": "50 messages inspirants pour la clarté, le courage et l'épanouissement.",
            "zh": "50 条启发灵感的讯息，唤醒清晰方向、勇气与有意义的成长。",
        },
    },
    "relationship": {
        "title": {"ko": "따뜻한 정원", "ja": "温かい庭園", "fr": "Jardin Chaleureux", "zh": "温暖花园"},
        "subtitle": {"ko": "사랑 & 연결", "ja": "愛とつながり", "fr": "Amour & Connexion", "zh": "爱与联结"},
        "description": {
            "ko": "공감, 진실한 소통, 깊은 유대감을 키우는 50가지 따뜻한 메시지.",
            "ja": "共感、誠実な対話、深い絆を育む50の心温まるメッセージ。",
            "fr": "50 messages bienveillants pour cultiver l'empathie et des liens profonds.",
            "zh": "50 条温暖心扉的寄语，培育同理心、真诚沟通与深厚联结。",
        },
    },
}

VISION_CATEGORIES_TRANS = {
    "LOVE": {"ko": "사랑 & 관계", "ja": "愛と人間関係", "fr": "Amour & Relations", "zh": "爱与关系"},
    "CAREER": {"ko": "커리어 & 삶의 목적", "ja": "キャリアと目的", "fr": "Carrière & Mission", "zh": "事业与人生目标"},
    "MONEY": {"ko": "재정 & 풍요", "ja": "お金と豊かさ", "fr": "Argent & Abondance", "zh": "财富与丰盛"},
    "HEALTH": {"ko": "건강 & 웰니스", "ja": "健康とウェルネス", "fr": "Santé & Bien-être", "zh": "健康与身心活力"},
    "HOME": {"ko": "안식처 & 집", "ja": "住まい・我が家", "fr": "Maison & Foyer", "zh": "理想家园"},
    "TRAVEL": {"ko": "여행 & 경험", "ja": "旅と体験", "fr": "Voyages & Expériences", "zh": "旅行与体验"},
    "FAMILY": {"ko": "가족", "ja": "家族", "fr": "Famille", "zh": "家庭"},
    "GROWTH": {"ko": "자기 성장 & 자신감", "ja": "自己成長と自信", "fr": "Croissance & Confiance", "zh": "个人成长与自信"},
    "PEACE": {"ko": "내면의 평화", "ja": "心の平穏", "fr": "Paix intérieure", "zh": "内心平静"},
}


def update_intentions():
    path = CONTENT_DIR / "intentions.json"
    data = json.loads(path.read_text(encoding="utf-8"))
    for item in data["intentions"]:
        code = item["code"]
        if code in INTENTIONS_TRANS:
            for lang, label in INTENTIONS_TRANS[code].items():
                item["text"][lang] = {"label": label}
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("Updated intentions.json")


def update_comfort_zone():
    path = CONTENT_DIR / "comfort_zone.json"
    data = json.loads(path.read_text(encoding="utf-8"))
    for cat in data["categories"]:
        cid = cat["id"]
        if cid in CZ_CATEGORIES_TRANS:
            for field in ("title", "subtitle", "description"):
                cat[field].update(CZ_CATEGORIES_TRANS[cid][field])
    for scene in data["scenes"]:
        sid = scene["id"]
        scene["title"] = {
            "vi": scene["titleVi"],
            "en": scene["titleEn"],
        }
        if sid in CZ_SCENES_TRANS:
            scene["title"].update(CZ_SCENES_TRANS[sid]["title"])
            scene["affirmation"].update(CZ_SCENES_TRANS[sid]["affirmation"])
            for lang in ("ko", "ja", "fr", "zh"):
                scene["description"][lang] = scene["description"].get("en", "")
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("Updated comfort_zone.json")


def update_audio_manifest():
    path = CONTENT_DIR / "audio_manifest.json"
    data = json.loads(path.read_text(encoding="utf-8"))
    native_guided = {
        "GA-32": "ga-32-mothers-morning-greeting.m4a",
        "GA-33": "ga-33-gryffindor-winter-sanctuary.m4a",
        "GA-34": "ga-34-autumn-thanksgiving-gratitude.m4a",
    }
    for asset in data["assets"]:
        aid = asset["id"]
        if aid in AUDIO_TITLES_TRANS:
            asset["titles"].update(AUDIO_TITLES_TRANS[aid])
        if "subtitles" in asset and asset["subtitles"]:
            en_sub = asset["subtitles"].get("en", "")
            freq = asset.get("frequency", "")
            title_map = asset["titles"]
            for lang in ("ko", "ja", "fr", "zh"):
                if freq and lang in title_map:
                    asset["subtitles"][lang] = f"{freq} • {title_map[lang]}"
                else:
                    asset["subtitles"][lang] = en_sub
        if "localePaths" in asset and asset["localePaths"]:
            en_path = asset["localePaths"]["en"]
            for lang in ("ko", "ja", "fr", "zh"):
                if aid in native_guided:
                    asset["localePaths"][lang] = f"assets/audio/guided/{lang}/{native_guided[aid]}"
                else:
                    asset["localePaths"][lang] = en_path
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("Updated audio_manifest.json")


def update_card_decks():
    path = CONTENT_DIR / "card_decks.json"
    data = json.loads(path.read_text(encoding="utf-8"))
    for deck in data["decks"]:
        did = deck["id"]
        if did in DECKS_TRANS:
            for field in ("title", "subtitle", "description"):
                deck[field].update(DECKS_TRANS[did][field])
        for card in deck["cards"]:
            en_text = card["text"].get("en", "")
            for lang in ("ko", "ja", "fr", "zh"):
                card["text"].setdefault(lang, en_text)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("Updated card_decks.json")


def update_vision():
    path = CONTENT_DIR / "vision.json"
    data = json.loads(path.read_text(encoding="utf-8"))
    for cat in data["categories"]:
        code = cat["code"]
        if code in VISION_CATEGORIES_TRANS:
            for lang, name in VISION_CATEGORIES_TRANS[code].items():
                cat["text"][lang] = {"name": name}
    for section in ("feelings", "questions", "answers", "templates"):
        for item in data[section]:
            en_obj = item["text"].get("en", {})
            for lang in ("ko", "ja", "fr", "zh"):
                item["text"].setdefault(lang, dict(en_obj))
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("Updated vision.json")


def main():
    update_intentions()
    update_comfort_zone()
    update_audio_manifest()
    update_card_decks()
    update_vision()


if __name__ == "__main__":
    main()
