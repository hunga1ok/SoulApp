import os
import sys
import json
import zipfile
import xml.etree.ElementTree as ET
from PIL import Image

sys.stdout.reconfigure(encoding='utf-8')

src_dir = r'C:\Users\HungAn\Documents\Codex\2026-10-05\https-github-com-hunga1ok-soulapp-clone\SoulApp\assets\asset'
target_content = r'c:\Users\HungAn\Documents\0.Project\1.Flutter\SoulApp\assets\content\card_decks.json'
target_images_base = r'c:\Users\HungAn\Documents\0.Project\1.Flutter\SoulApp\assets\images\cards'

os.makedirs(os.path.dirname(target_content), exist_ok=True)

ns = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}

def parse_docx(path):
    with zipfile.ZipFile(path) as z:
        xml = z.read('word/document.xml')
    tree = ET.fromstring(xml)
    rows = tree.findall('.//w:tr', ns)
    data = []
    for r in rows[1:]:
        cells = [''.join(n.text for n in c.findall('.//w:t', ns) if n.text).strip() for c in r.findall('.//w:tc', ns)]
        if len(cells) >= 3 and cells[0].isdigit():
            num = int(cells[0])
            vi = cells[1]
            en = cells[2]
            prompt = cells[3] if len(cells) > 3 else ''
            data.append({'number': num, 'vi': vi, 'en': en, 'prompt': prompt})
    return data

def get_sorted_images(folder, exclude=None):
    p = os.path.join(src_dir, folder)
    files = [f for f in os.listdir(p) if f.endswith('.png')]
    if exclude:
        files = [f for f in files if f not in exclude]
    files.sort(key=lambda x: os.path.getmtime(os.path.join(p, x)))
    return [os.path.join(p, f) for f in files]

deck_configs = [
    {
        'id': 'healing',
        'code': 'OCEAN_HEALING',
        'title': {'vi': 'Đại dương xanh', 'en': 'Blue Ocean'},
        'subtitle': {'vi': 'Chữa lành tâm hồn', 'en': 'Soul Healing'},
        'description': {
            'vi': '50 thông điệp nhẹ nhàng, tĩnh lặng và dịu dàng với chính mình.',
            'en': '50 gentle messages nurturing stillness and self-compassion.'
        },
        'ambientTrackId': 'SO-05',
        'docx': os.path.join(src_dir, 'Bo1_healing', 'Soul_50_Thong_Diep_Chua_Lanh_Tam_Hon_Bilingual.docx'),
        'images': get_sorted_images('Bo1_healing', [
            'Ảnh ChatGPT 09_41_08 6 thg 10, 2026-1.png',
            'Ảnh ChatGPT 09_48_56 6 thg 10, 2026-5.png'
        ]),
        'target_folder': 'healing'
    },
    {
        'id': 'career',
        'code': 'GREEN_MEADOW',
        'title': {'vi': 'Đồng cỏ xanh', 'en': 'Green Meadow'},
        'subtitle': {'vi': 'Học tập & Sự nghiệp', 'en': 'Study & Growth'},
        'description': {
            'vi': '50 thông điệp động viên, kiên định và giữ vững nhịp điệu của bạn.',
            'en': '50 encouraging messages to keep your pace and steady rhythm.'
        },
        'ambientTrackId': 'SO-11',
        'docx': os.path.join(src_dir, 'Bo2_green', 'Soul_50_Thong_Diep_Hoc_Tap_Su_Nghiep_Green_Meadow_Bilingual.docx'),
        'images': get_sorted_images('Bo2_green'),
        'target_folder': 'career'
    },
    {
        'id': 'relationship',
        'code': 'FLORAL_RELATIONSHIP',
        'title': {'vi': 'Hoa cỏ tình cảm', 'en': 'Floral Relationship'},
        'subtitle': {'vi': 'Tình cảm & Mối quan hệ', 'en': 'Love & Connections'},
        'description': {
            'vi': '50 thông điệp ấm áp, chân thành cho các mối quan hệ và sự gắn kết.',
            'en': '50 warm and honest messages for meaningful connections.'
        },
        'ambientTrackId': 'SO-18',
        'docx': os.path.join(src_dir, 'Bo3-flower', 'Soul_50_Thong_Diep_Tinh_Cam_Moi_Quan_He_Bilingual.docx'),
        'images': get_sorted_images('Bo3-flower'),
        'target_folder': 'relationship'
    }
]

decks_data = []

for cfg in deck_configs:
    messages = parse_docx(cfg['docx'])
    images = cfg['images']
    target_img_dir = os.path.join(target_images_base, cfg['target_folder'])
    os.makedirs(target_img_dir, exist_ok=True)

    cards = []
    print(f"Processing {cfg['id']}: {len(messages)} messages, {len(images)} images...")

    for i, msg in enumerate(messages):
        card_num = msg['number']
        card_id = f"{cfg['id']}_{card_num:02d}"
        rel_img_path = f"assets/images/cards/{cfg['target_folder']}/card_{card_num:02d}.webp"
        target_img_full = os.path.join(target_images_base, cfg['target_folder'], f"card_{card_num:02d}.webp")

        if i < len(images):
            src_img = images[i]
            if not os.path.exists(target_img_full):
                with Image.open(src_img) as im:
                    im = im.convert('RGB')
                    im.thumbnail((1200, 1200), Image.Resampling.LANCZOS)
                    im.save(target_img_full, 'WEBP', quality=85, method=4)

        cards.append({
            'id': card_id,
            'number': card_num,
            'text': {
                'vi': msg['vi'],
                'en': msg['en']
            },
            'imagePrompt': msg['prompt'],
            'imagePath': rel_img_path
        })

    decks_data.append({
        'id': cfg['id'],
        'code': cfg['code'],
        'title': cfg['title'],
        'subtitle': cfg['subtitle'],
        'description': cfg['description'],
        'ambientTrackId': cfg['ambientTrackId'],
        'cardCount': len(cards),
        'cards': cards
    })

with open(target_content, 'w', encoding='utf-8') as f:
    json.dump({'decks': decks_data}, f, ensure_ascii=False, indent=2)

print('Done exporting card_decks.json and WebP images!')
