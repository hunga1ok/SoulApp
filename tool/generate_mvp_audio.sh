#!/usr/bin/env bash
set -euo pipefail

# Generates original, local MVP audio assets. Sound beds are synthesized from
# noise and low-level tones; guided voice is rendered separately in vi-VN and
# en-US. Re-running the script replaces only generated asset paths.

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
audio_dir="$root_dir/assets/audio"
temp_dir="$(mktemp -d)"
trap 'rm -rf "$temp_dir"' EXIT

mkdir -p "$audio_dir/ambience" "$audio_dir/music" \
  "$audio_dir/guided/vi" "$audio_dir/guided/en"

make_bed() {
  local output="$1"
  local color="$2"
  local frequency="$3"
  local pulse="$4"
  [[ -f "$output" ]] && return
  ffmpeg -hide_banner -loglevel error -y \
    -f lavfi -i "anoisesrc=color=${color}:amplitude=0.11:sample_rate=44100" \
    -f lavfi -i "sine=frequency=${frequency}:sample_rate=44100" \
    -f lavfi -i "sine=frequency=${pulse}:sample_rate=44100" \
    -filter_complex "[0:a]lowpass=f=280,volume=0.40[n];[1:a]volume=0.020[tone];[2:a]volume=0.008[pulse];[n][tone][pulse]amix=inputs=3:normalize=0,afade=t=in:st=0:d=2,afade=t=out:st=56:d=4" \
    -t 60 -c:a aac -b:a 96k "$output"
}

make_guided() {
  local locale="$1"
  local code="$2"
  local slug="$3"
  local text="$4"
  local voice frequency voice_file output code_lower
  if [[ "$locale" == "vi" ]]; then
    voice="Linh"
    frequency=174
  else
    voice="Samantha"
    frequency=196
  fi
  code_lower=$(printf '%s' "$code" | tr '[:upper:]' '[:lower:]')
  voice_file="$temp_dir/${locale}-${code}.aiff"
  output="$audio_dir/guided/${locale}/${code_lower}-${slug}.m4a"
  [[ -f "$output" ]] && return
  say -v "$voice" -r 145 -o "$voice_file" "$text"
  ffmpeg -hide_banner -loglevel error -y -i "$voice_file" \
    -f lavfi -i "anoisesrc=color=pink:amplitude=0.025:sample_rate=44100" \
    -f lavfi -i "sine=frequency=${frequency}:sample_rate=44100" \
    -filter_complex "[1:a]lowpass=f=220,volume=0.20[air];[2:a]volume=0.009[bed];[0:a][air][bed]amix=inputs=3:duration=first:normalize=0,afade=t=in:st=0:d=1,afade=t=out:st=0:d=2" \
    -shortest -c:a aac -b:a 96k -metadata title="$code Soul guided preview" "$output"
}

# Renders the canonical text directly from the production script. The document
# is the source of truth: this avoids maintaining a shortened duplicate here.
make_guided_from_production_script() {
  local locale="$1"
  local code="$2"
  local slug="$3"
  local language voice frequency voice_file output code_lower text
  local script_file="$root_dir/../Specs/Soul_Full_Audio_Scripts_VI_EN_Production_v2.1.md"
  language=$([[ "$locale" == "vi" ]] && printf 'VI' || printf 'EN')
  voice=$([[ "$locale" == "vi" ]] && printf 'Linh' || printf 'Samantha')
  frequency=$([[ "$locale" == "vi" ]] && printf '174' || printf '196')
  code_lower=$(printf '%s' "$code" | tr '[:upper:]' '[:lower:]')
  voice_file="$temp_dir/${locale}-${code}-full.aiff"
  output="$audio_dir/guided/${locale}/${code_lower}-${slug}.m4a"
  text=$(awk -v id="$code" -v language="$language" '
    $0 ~ "^### " id " " { in_track = 1; next }
    in_track && /^### GA-/ { exit }
    in_track && $0 == "#### " language " --- Final recording script" {
      capture = 1; next
    }
    capture && /^#### / { exit }
    capture {
      if (index($0, "[") == 1 || $0 ~ /^-+$/) next
      if (length($0) > 0) printf "%s ", $0
    }
  ' "$script_file")
  [[ -n "$text" ]] || { echo "Missing $code $language script" >&2; exit 1; }
  say -v "$voice" -r 145 -o "$voice_file" "$text"
  ffmpeg -hide_banner -loglevel error -y -i "$voice_file" \
    -f lavfi -i "anoisesrc=color=pink:amplitude=0.025:sample_rate=44100" \
    -f lavfi -i "sine=frequency=${frequency}:sample_rate=44100" \
    -filter_complex "[1:a]lowpass=f=220,volume=0.20[air];[2:a]volume=0.009[bed];[0:a][air][bed]amix=inputs=3:duration=first:normalize=0,afade=t=in:st=0:d=1,afade=t=out:st=0:d=2" \
    -shortest -c:a aac -b:a 96k -metadata title="$code Soul guided audio" "$output"
}

render_production_track() {
  local code="$1"
  local slug="$2"
  make_guided_from_production_script vi "$code" "$slug"
  make_guided_from_production_script en "$code" "$slug"
}

make_bed "$audio_dir/ambience/so-03-window-rain.m4a" pink 138 69
make_bed "$audio_dir/ambience/so-05-ocean-breath.m4a" pink 110 55
make_bed "$audio_dir/ambience/so-07-fireplace-room.m4a" brown 96 48
make_bed "$audio_dir/ambience/so-09-brown-noise.m4a" brown 72 36
make_bed "$audio_dir/ambience/so-10-soft-sound-bath.m4a" violet 174 87
make_bed "$audio_dir/music/so-11-warm-felt-piano.m4a" pink 220 110
make_bed "$audio_dir/music/so-12-future-horizon.m4a" pink 247 123
make_bed "$audio_dir/music/so-13-golden-flow.m4a" pink 264 132
make_bed "$audio_dir/music/so-14-rooted-calm.m4a" brown 216 108
make_bed "$audio_dir/music/so-15-abundance-current.m4a" pink 222 111
make_bed "$audio_dir/music/so-16-open-sky-handpan.m4a" pink 294 147
make_bed "$audio_dir/music/so-17-warm-rnb-ambient.m4a" brown 196 98
make_bed "$audio_dir/music/so-18-heart-space.m4a" pink 233 116
make_bed "$audio_dir/music/so-19-quiet-momentum.m4a" brown 262 131
make_bed "$audio_dir/music/so-20-dreamy-ethereal.m4a" violet 330 165

make_guided vi GA-21 my-financial-future 'Hãy hình dung một tương lai tài chính rộng rãi hơn. Bạn có thêm lựa chọn, thêm bình tĩnh, và biết cách chăm sóc những điều quan trọng. Hãy mở lòng với những cơ hội, ý tưởng và công việc phù hợp với giá trị của bạn. Ngay hôm nay, một bước nhỏ cũng là một hướng đi.'
make_guided en GA-21 my-financial-future 'Picture a financial future with more ease and more choice. You have room to care for what matters, and the steadiness to make intentional decisions. Stay open to opportunities, ideas, and work that fits your values. One small step today is already a direction.'
make_guided vi GA-23 open-to-healthy-love 'Hãy để mình hình dung một tình yêu lành mạnh. Một nơi có sự an toàn, tôn trọng, ấm áp và thành thật. Bạn không cần biết ai sẽ xuất hiện. Chỉ cần nhận ra cách bạn muốn được yêu, và cách bạn muốn có mặt trong một mối quan hệ tốt đẹp.'
make_guided en GA-23 open-to-healthy-love 'Imagine the quality of healthy love. A place with safety, respect, warmth, and honesty. You do not need to know who will arrive. Simply notice how you want to be loved, and how you want to show up in a caring relationship.'
make_guided vi GA-25 future-career-self 'Hãy bước vào một ngày làm việc bình thường của phiên bản tương lai. Bạn đang đóng góp điều gì, làm việc cùng ai, và sử dụng năng lực nào với sự tự tin? Không cần hoàn hảo. Chỉ cần chọn một kỹ năng, một cuộc trò chuyện, hoặc một hành động có thể bắt đầu hôm nay.'
make_guided en GA-25 future-career-self 'Step into an ordinary workday of your future self. What are you contributing, who are you working with, and which strengths are you using with confidence? It does not have to be perfect. Choose one skill, conversation, or action you can begin today.'
make_guided vi GA-27 a-body-i-care-for 'Hãy trở về với cơ thể của bạn bằng sự tôn trọng. Nhận ra một điều cơ thể đang làm cho bạn, và cho phép mình chăm sóc điều đó bằng một lựa chọn dịu dàng. Bạn không cần thay đổi tất cả. Chỉ cần lắng nghe và đáp lại bằng sự tử tế.'
make_guided en GA-27 a-body-i-care-for 'Return to your body with respect. Notice one thing your body is already doing for you, then offer it one gentle act of care. You do not need to change everything. Simply listen, and respond with kindness.'
make_guided vi GA-28 come-home-to-your-future 'Hãy đi vào ngôi nhà tương lai của bạn bằng những chi tiết dịu dàng: ánh sáng, âm thanh, nhịp sống, những người bạn yêu thương. Điều quan trọng không phải là sự xa hoa, mà là cảm giác an toàn và thuộc về. Hôm nay, bạn có thể tạo một phần rất nhỏ của cảm giác ấy ở đâu?'
make_guided en GA-28 come-home-to-your-future 'Enter your future home through gentle details: light, sound, pace, and the people you love. What matters is not luxury, but safety and belonging. Where could you create one small part of that feeling today?'
make_guided vi GA-29 a-life-with-more-wonder 'Hãy hình dung một cuộc sống có thêm sự tò mò, tự do và khám phá. Bạn đang đi đâu, học điều gì, và cảm thấy rộng mở ra sao? Để điều đó gần hơn, hãy chọn một bước thực tế: tìm hiểu, tiết kiệm, học hỏi, hoặc lên lịch cho một trải nghiệm mới.'
make_guided en GA-29 a-life-with-more-wonder 'Imagine a life with more curiosity, freedom, and discovery. Where are you going, what are you learning, and how does that openness feel? Bring it closer with one practical step: research, save, learn, or schedule a new experience.'
make_guided vi GA-30 a-home-between-us 'Hãy nhớ về cảm giác thuộc về giữa những người thân yêu. Một không gian có sự lắng nghe, quan tâm và đủ chỗ cho mỗi người được là mình. Bạn có thể mang thêm một chút ấm áp vào mối quan hệ của mình bằng một lời hỏi thăm, một cuộc gọi, hoặc một khoảnh khắc hiện diện.'
make_guided en GA-30 a-home-between-us 'Remember the feeling of belonging among people you care about. A space with listening, warmth, and room for everyone to be themselves. You can bring a little more of that feeling into a relationship through a message, a call, or one present moment.'
make_guided vi GA-31 return-to-yourself 'Trong vài phút này, bạn không cần trở thành một phiên bản nào khác. Chỉ cần nhận ra hơi thở, cơ thể và căn phòng đang ở đây. Bạn không cần giải quyết mọi thứ ngay bây giờ. Hãy trở về với chính mình, nhẹ nhàng và đủ đầy.'
make_guided en GA-31 return-to-yourself 'For these few minutes, you do not need to become anyone else. Notice your breath, your body, and the room around you. You do not have to solve everything right now. Return to yourself, gently and completely.'
make_guided vi GA-18 step-into-your-future 'Hãy nhìn về phiên bản tương lai mà bạn đang trở thành. Không cần biết chính xác con đường. Chỉ cần để mình thấy rõ hơn nhịp sống, những mối quan hệ và công việc bạn đang hướng tới. Rồi quay về hôm nay với một bước nhỏ, cụ thể và có thể làm được.'
make_guided en GA-18 step-into-your-future 'Step toward the future self you are becoming. You do not need to know the exact path. Let yourself see more clearly the rhythm of life, relationships, and work you are moving toward. Then return to today with one small, concrete step you can take.'

if [[ $# -gt 0 ]]; then
  case "$1" in
    GA-18) render_production_track GA-18 step-into-your-future ;;
    GA-21) render_production_track GA-21 my-financial-future ;;
    GA-23) render_production_track GA-23 open-to-healthy-love ;;
    GA-25) render_production_track GA-25 future-career-self ;;
    GA-27) render_production_track GA-27 a-body-i-care-for ;;
    GA-28) render_production_track GA-28 come-home-to-your-future ;;
    GA-29) render_production_track GA-29 a-life-with-more-wonder ;;
    GA-30) render_production_track GA-30 a-home-between-us ;;
    GA-31) render_production_track GA-31 return-to-yourself ;;
    *) echo "Unknown production track: $1" >&2; exit 2 ;;
  esac
else
  render_production_track GA-18 step-into-your-future
  render_production_track GA-21 my-financial-future
  render_production_track GA-23 open-to-healthy-love
  render_production_track GA-25 future-career-self
  render_production_track GA-27 a-body-i-care-for
  render_production_track GA-28 come-home-to-your-future
  render_production_track GA-29 a-life-with-more-wonder
  render_production_track GA-30 a-home-between-us
  render_production_track GA-31 return-to-yourself
fi

echo "Generated $(find "$audio_dir" -type f -name '*.m4a' | wc -l | tr -d ' ') audio assets in $audio_dir"
