# Soul_Vision_Board_Content_Dataset_v1.2

Source: `Soul_Vision_Board_Content_Dataset_v1.2.xlsx`

## Sheet Overview

| SOUL — Guided Vision Board Dataset v1.0 |  |
| --- | --- |
| Purpose | Dataset để triển khai Guided Vision Board theo nguyên tắc Select → Fill → Follow. User không bắt đầu từ canvas trắng. |
| MVP categories | 9: Love & Relationships, Career & Purpose, Money & Abundance, Health & Wellness, Home, Travel & Experiences, Family, Personal Growth & Confidence, Inner Peace. |
| Question volume | 81 guided questions (9/category), có suggested answers và custom input. |
| Statement logic | Statement templates dùng placeholder để ghép câu trả lời; user luôn được quyền sửa trước khi lưu. |
| Audio rule | Vision Session chỉ dùng Soul-owned hoặc licensed audio, được chọn theo Vision Category. YouTube/Spotify chỉ dùng cho curated external recommendations. |
| Language | Dataset master viết song ngữ EN/VI ở các field hiển thị chính; kiến trúc CMS nên dùng translation table. |
| Safety | Không hứa hẹn manifest chắc chắn tạo ra kết quả; với Health/Money tránh claim điều trị, đầu tư hoặc kết quả bảo đảm. |
| Recommended flow | Category → Guided Questions → Desired Feelings → Statement → Image → Sound → Preview → Save → Vision Session. |
| Workbook Sheets |  |
| Vision Categories | 9 category definitions + default audio/session settings |
| Guided Questions | 81 question records with EN/VI copy, type and required flag |
| Suggested Answers | Reusable suggested options for each question |
| Feelings | Feeling dictionary for user selection and recommendation tags |
| Statement Templates | Vision statement templates with placeholders |
| Affirmations | Soul-owned affirmation copy by category |
| Audio Mapping | Owned/licensed audio mapping rules |
| External Mapping | YouTube/Spotify recommendation slots/keywords, not rehosted |
| Vision Sessions | Preset guided Vision Session formats |
| CMS Import Notes | Import order, enums and implementation rules |

## Sheet Vision Categories

| Category ID | Code | Name EN | Name VI | Icon | Core Intent | Default Feelings | Default Owned Audio | Default Session | Sort | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| CAT01 | LOVE | Love & Relationships | Tình yêu & Mối quan hệ | ❤️ | Build a vision for healthy, reciprocal and meaningful connection. | Loved;Safe;Connected;Understood;Gentle;Trusting | Open Heart | Heart & Connection | 1 | ACTIVE |
| CAT02 | CAREER | Career & Purpose | Sự nghiệp & Mục đích | 💼 | Clarify meaningful work, growth, contribution and preferred work life. | Confident;Free;Inspired;Recognized;Focused;Proactive | Becoming | Future Self Focus | 2 | ACTIVE |
| CAT03 | MONEY | Money & Abundance | Tài chính & Sự đủ đầy | 💰 | Define financial goals and the sense of security/freedom they support. | Secure;Free;Abundant;Reassured;Expansive;Proactive | Golden Flow | Abundance & Action | 3 | ACTIVE |
| CAT04 | HEALTH | Health & Wellness | Sức khỏe & Thể chất | 🌿 | Visualize supportive routines, vitality, rest and sustainable wellbeing. | Energized;Strong;Relieved;Balanced;Cared for;Peaceful | Gentle Vitality | Wellbeing Vision | 4 | ACTIVE |
| CAT05 | HOME | Home | Ngôi nhà | 🏡 | Describe the environment, atmosphere and daily life of an ideal home. | Safe;Peaceful;Warm;Belonging;Rested;Connected | Quiet Home | Home Visualization | 5 | ACTIVE |
| CAT06 | TRAVEL | Travel & Experiences | Du lịch & Trải nghiệm | ✈️ | Clarify places, experiences and feelings the user wants to create. | Free;Curious;Alive;Expansive;Excited;Rested | Open Horizon | Experience Reel | 6 | ACTIVE |
| CAT07 | FAMILY | Family | Gia đình | 👨‍👩‍👧 | Envision supportive family connection, rituals and shared experiences. | Loved;Connected;Grateful;Understood;Warm;Reassured | Warm Light | Family Moments | 7 | ACTIVE |
| CAT08 | GROWTH | Personal Growth & Confidence | Phát triển bản thân & Tự tin | ✨ | Define the person the user is becoming and qualities they want to practice. | Confident;Proud;Courageous;Steady;Inspired;Expansive | Inner Strength | Becoming Me | 8 | ACTIVE |
| CAT09 | PEACE | Inner Peace | Bình an nội tâm | 🧘 | Create a vision for calm, boundaries, rest and emotional spaciousness. | Peaceful;Safe;Grounded;Relieved;Still;Balanced | Stillness | Quiet Mind | 9 | ACTIVE |

## Sheet Guided Questions

| Question ID | Category ID | Order | Field Key | Question EN | Question VI | Question Type | Required | Max Select | Placeholder EN | Placeholder VI | Logic Tag |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| CAT01_Q01 | CAT01 | 1 | relationship_type | What kind of relationship are you creating? | Bạn muốn xây dựng một mối quan hệ như thế nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | RELATIONSHIP_TYPE |
| CAT01_Q02 | CAT01 | 2 | daily_connection | What would everyday connection look like? | Sự kết nối trong đời sống hằng ngày sẽ trông như thế nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | DAILY_CONNECTION |
| CAT01_Q03 | CAT01 | 3 | communication | How do you want communication to feel? | Bạn muốn cách giao tiếp mang lại cảm giác gì? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | COMMUNICATION |
| CAT01_Q04 | CAT01 | 4 | quality_time | What do you want to enjoy together? | Bạn muốn cùng nhau tận hưởng điều gì? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | QUALITY_TIME |
| CAT01_Q05 | CAT01 | 5 | support | What kind of support matters most? | Sự hỗ trợ nào quan trọng nhất với bạn? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | SUPPORT |
| CAT01_Q06 | CAT01 | 6 | boundaries | Which boundaries help this relationship stay healthy? | Ranh giới nào giúp mối quan hệ lành mạnh? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | BOUNDARIES |
| CAT01_Q07 | CAT01 | 7 | future | What future do you hope to build together? | Bạn hy vọng cùng nhau xây dựng tương lai như thế nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | FUTURE |
| CAT01_Q08 | CAT01 | 8 | self_role | Who do you want to be in this relationship? | Bạn muốn trở thành phiên bản nào của mình trong mối quan hệ? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | SELF_ROLE |
| CAT01_Q09 | CAT01 | 9 | first_action | What is one small action you can practice now? | Một hành động nhỏ bạn có thể thực hành ngay là gì? | SINGLE_SELECT | Y | 1 | Add your own answer | Thêm câu trả lời của bạn | FIRST_ACTION |
| CAT02_Q01 | CAT02 | 1 | work_type | What kind of work do you want to spend your time on? | Bạn muốn dành thời gian cho loại công việc nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | WORK_TYPE |
| CAT02_Q02 | CAT02 | 2 | impact | What impact do you want your work to create? | Bạn muốn công việc tạo ra tác động gì? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | IMPACT |
| CAT02_Q03 | CAT02 | 3 | environment | What work environment suits you? | Môi trường làm việc nào phù hợp với bạn? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | ENVIRONMENT |
| CAT02_Q04 | CAT02 | 4 | time | How much freedom do you want over your schedule? | Bạn mong muốn mức độ tự do về thời gian như thế nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | TIME |
| CAT02_Q05 | CAT02 | 5 | income | What income or financial milestone would support this vision? | Mốc thu nhập nào hỗ trợ cho tầm nhìn này? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | INCOME |
| CAT02_Q06 | CAT02 | 6 | growth | What would you like to become better at? | Bạn muốn giỏi hơn ở điều gì? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | GROWTH |
| CAT02_Q07 | CAT02 | 7 | recognition | How do you want your contribution to be recognized? | Bạn muốn đóng góp của mình được ghi nhận như thế nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | RECOGNITION |
| CAT02_Q08 | CAT02 | 8 | work_feeling | How do you want to feel at the end of a good workday? | Cuối một ngày làm việc tốt, bạn muốn cảm thấy thế nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | WORK_FEELING |
| CAT02_Q09 | CAT02 | 9 | first_action | What is one step your future self would take this week? | Một bước mà phiên bản tương lai của bạn sẽ làm trong tuần này là gì? | SINGLE_SELECT | Y | 1 | Add your own answer | Thêm câu trả lời của bạn | FIRST_ACTION |
| CAT03_Q01 | CAT03 | 1 | meaning | What does financial abundance mean to you? | Sự đủ đầy tài chính có ý nghĩa gì với bạn? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | MEANING |
| CAT03_Q02 | CAT03 | 2 | target | Is there a financial milestone you want to work toward? | Có cột mốc tài chính nào bạn muốn hướng tới không? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | TARGET |
| CAT03_Q03 | CAT03 | 3 | lifestyle | What would financial stability allow you to do? | Sự ổn định tài chính sẽ cho phép bạn làm gì? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | LIFESTYLE |
| CAT03_Q04 | CAT03 | 4 | habits | Which money habits belong in this vision? | Thói quen tài chính nào thuộc về tầm nhìn này? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | HABITS |
| CAT03_Q05 | CAT03 | 5 | earning | How would you like to grow your earning capacity? | Bạn muốn phát triển khả năng tạo thu nhập như thế nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | EARNING |
| CAT03_Q06 | CAT03 | 6 | relationship_money | How do you want to feel when dealing with money? | Bạn muốn cảm thấy thế nào khi xử lý tiền bạc? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | RELATIONSHIP_MONEY |
| CAT03_Q07 | CAT03 | 7 | giving | Does generosity have a place in your financial vision? | Sự hào phóng có vị trí nào trong tầm nhìn tài chính của bạn? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | GIVING |
| CAT03_Q08 | CAT03 | 8 | future_scene | Picture a financially peaceful day. What is different? | Hình dung một ngày bình yên về tài chính. Điều gì khác đi? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | FUTURE_SCENE |
| CAT03_Q09 | CAT03 | 9 | first_action | What is one grounded money action you can take now? | Một hành động tài chính thực tế bạn có thể làm ngay là gì? | SINGLE_SELECT | Y | 1 | Add your own answer | Thêm câu trả lời của bạn | FIRST_ACTION |
| CAT04_Q01 | CAT04 | 1 | wellbeing | What does feeling well mean to you? | Cảm thấy khỏe mạnh có ý nghĩa gì với bạn? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | WELLBEING |
| CAT04_Q02 | CAT04 | 2 | movement | What kind of movement would you enjoy regularly? | Bạn muốn duy trì kiểu vận động nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | MOVEMENT |
| CAT04_Q03 | CAT04 | 3 | sleep | What would a supportive sleep routine look like? | Một thói quen ngủ tốt sẽ như thế nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | SLEEP |
| CAT04_Q04 | CAT04 | 4 | food | How do you want to approach food and nourishment? | Bạn muốn tiếp cận ăn uống và dinh dưỡng như thế nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | FOOD |
| CAT04_Q05 | CAT04 | 5 | stress | What helps you recover from stress? | Điều gì giúp bạn hồi phục sau căng thẳng? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | STRESS |
| CAT04_Q06 | CAT04 | 6 | environment | What environment supports your wellbeing? | Môi trường nào hỗ trợ sức khỏe của bạn? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | ENVIRONMENT |
| CAT04_Q07 | CAT04 | 7 | body_relation | How do you want to relate to your body? | Bạn muốn có mối quan hệ như thế nào với cơ thể mình? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | BODY_RELATION |
| CAT04_Q08 | CAT04 | 8 | support | What support would help you stay consistent? | Hỗ trợ nào giúp bạn duy trì đều đặn? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | SUPPORT |
| CAT04_Q09 | CAT04 | 9 | first_action | What is one small wellbeing action for today? | Một hành động nhỏ cho sức khỏe hôm nay là gì? | SINGLE_SELECT | Y | 1 | Add your own answer | Thêm câu trả lời của bạn | FIRST_ACTION |
| CAT05_Q01 | CAT05 | 1 | location | Where does your ideal home feel like it belongs? | Ngôi nhà lý tưởng của bạn thuộc về nơi như thế nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | LOCATION |
| CAT05_Q02 | CAT05 | 2 | space | What spaces matter most in your home? | Những không gian nào quan trọng nhất trong nhà? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | SPACE |
| CAT05_Q03 | CAT05 | 3 | style | What atmosphere do you want your home to have? | Bạn muốn ngôi nhà mang bầu không khí nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | STYLE |
| CAT05_Q04 | CAT05 | 4 | morning | What does a peaceful morning at home look like? | Một buổi sáng bình yên ở nhà trông như thế nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | MORNING |
| CAT05_Q05 | CAT05 | 5 | evening | What does an ideal evening at home feel like? | Một buổi tối lý tưởng ở nhà mang cảm giác gì? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | EVENING |
| CAT05_Q06 | CAT05 | 6 | people | Who shares this home with you? | Ai sẽ cùng bạn sống trong ngôi nhà này? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | PEOPLE |
| CAT05_Q07 | CAT05 | 7 | function | What should your home make easier? | Ngôi nhà nên giúp điều gì trở nên dễ dàng hơn? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | FUNCTION |
| CAT05_Q08 | CAT05 | 8 | feeling | What feeling should greet you when you walk in? | Bạn muốn cảm giác nào chào đón khi bước vào nhà? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | FEELING |
| CAT05_Q09 | CAT05 | 9 | first_action | What can you do now to bring a little of this home into today? | Bạn có thể làm gì ngay để mang một phần cảm giác ngôi nhà đó vào hôm nay? | SINGLE_SELECT | Y | 1 | Add your own answer | Thêm câu trả lời của bạn | FIRST_ACTION |
| CAT06_Q01 | CAT06 | 1 | destination | What kind of places do you want to experience? | Bạn muốn trải nghiệm những nơi như thế nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | DESTINATION |
| CAT06_Q02 | CAT06 | 2 | pace | How do you like to travel? | Bạn thích du lịch theo nhịp nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | PACE |
| CAT06_Q03 | CAT06 | 3 | people | Who would you love to travel with? | Bạn muốn đi cùng ai? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | PEOPLE |
| CAT06_Q04 | CAT06 | 4 | frequency | What travel rhythm fits your life? | Nhịp du lịch nào phù hợp với cuộc sống của bạn? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | FREQUENCY |
| CAT06_Q05 | CAT06 | 5 | experience | What experiences do you want to remember years later? | Trải nghiệm nào bạn muốn nhớ nhiều năm sau? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | EXPERIENCE |
| CAT06_Q06 | CAT06 | 6 | comfort | What level of comfort matters? | Mức độ thoải mái nào quan trọng với bạn? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | COMFORT |
| CAT06_Q07 | CAT06 | 7 | meaning | Why does travel matter to you? | Tại sao du lịch quan trọng với bạn? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | MEANING |
| CAT06_Q08 | CAT06 | 8 | memory | What would you love to bring home from these experiences? | Bạn muốn mang điều gì trở về từ những trải nghiệm đó? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | MEMORY |
| CAT06_Q09 | CAT06 | 9 | first_action | What is one step toward your next experience? | Một bước hướng tới trải nghiệm tiếp theo là gì? | SINGLE_SELECT | Y | 1 | Add your own answer | Thêm câu trả lời của bạn | FIRST_ACTION |
| CAT07_Q01 | CAT07 | 1 | connection | What kind of family connection do you want to cultivate? | Bạn muốn vun đắp kiểu kết nối gia đình nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | CONNECTION |
| CAT07_Q02 | CAT07 | 2 | rituals | Which family rituals would you love to have? | Bạn muốn có những nghi thức gia đình nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | RITUALS |
| CAT07_Q03 | CAT07 | 3 | home_feeling | How do you want family gatherings to feel? | Bạn muốn những buổi tụ họp gia đình mang cảm giác gì? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | HOME_FEELING |
| CAT07_Q04 | CAT07 | 4 | support | How do you want family members to support one another? | Bạn muốn các thành viên hỗ trợ nhau thế nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | SUPPORT |
| CAT07_Q05 | CAT07 | 5 | boundaries | What healthy boundaries matter to you? | Ranh giới lành mạnh nào quan trọng? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | BOUNDARIES |
| CAT07_Q06 | CAT07 | 6 | memories | What memories do you want to create together? | Bạn muốn cùng nhau tạo những ký ức nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | MEMORIES |
| CAT07_Q07 | CAT07 | 7 | role | Who do you want to be in your family? | Bạn muốn trở thành người như thế nào trong gia đình? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | ROLE |
| CAT07_Q08 | CAT07 | 8 | future | What would make you feel proud of your family life? | Điều gì khiến bạn tự hào về đời sống gia đình? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | FUTURE |
| CAT07_Q09 | CAT07 | 9 | first_action | What can you do this week for one person you love? | Tuần này bạn có thể làm gì cho một người mình yêu? | SINGLE_SELECT | Y | 1 | Add your own answer | Thêm câu trả lời của bạn | FIRST_ACTION |
| CAT08_Q01 | CAT08 | 1 | future_self | Which qualities define the person you are becoming? | Những phẩm chất nào định nghĩa con người bạn đang trở thành? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | FUTURE_SELF |
| CAT08_Q02 | CAT08 | 2 | voice | How do you want to speak and express yourself? | Bạn muốn nói và thể hiện bản thân như thế nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | VOICE |
| CAT08_Q03 | CAT08 | 3 | courage | What would you do if you trusted yourself more? | Bạn sẽ làm gì nếu tin vào bản thân hơn? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | COURAGE |
| CAT08_Q04 | CAT08 | 4 | skill | Which skill would change your life if you practiced it consistently? | Kỹ năng nào có thể thay đổi cuộc sống nếu bạn luyện đều? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | SKILL |
| CAT08_Q05 | CAT08 | 5 | habit | Which habit belongs to your future self? | Thói quen nào thuộc về phiên bản tương lai của bạn? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | HABIT |
| CAT08_Q06 | CAT08 | 6 | self_talk | How do you want your inner voice to sound? | Bạn muốn tiếng nói bên trong mình như thế nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | SELF_TALK |
| CAT08_Q07 | CAT08 | 7 | visibility | Where do you want to be more visible or expressive? | Bạn muốn hiện diện và thể hiện nhiều hơn ở đâu? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | VISIBILITY |
| CAT08_Q08 | CAT08 | 8 | proof | What would show you that you've grown? | Điều gì cho thấy bạn đã trưởng thành? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | PROOF |
| CAT08_Q09 | CAT08 | 9 | first_action | What is one brave but manageable action for today? | Một hành động dũng cảm nhưng vừa sức hôm nay là gì? | SINGLE_SELECT | Y | 1 | Add your own answer | Thêm câu trả lời của bạn | FIRST_ACTION |
| CAT09_Q01 | CAT09 | 1 | peace_meaning | What does inner peace look like in your real life? | Bình an nội tâm trông như thế nào trong cuộc sống thật của bạn? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | PEACE_MEANING |
| CAT09_Q02 | CAT09 | 2 | morning | How would a peaceful morning begin? | Một buổi sáng bình yên bắt đầu thế nào? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | MORNING |
| CAT09_Q03 | CAT09 | 3 | noise | What creates unnecessary noise in your life? | Điều gì tạo ra quá nhiều nhiễu trong cuộc sống? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | NOISE |
| CAT09_Q04 | CAT09 | 4 | boundary | Which boundary would protect your peace? | Ranh giới nào bảo vệ sự bình yên của bạn? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | BOUNDARY |
| CAT09_Q05 | CAT09 | 5 | reset | What helps you return to yourself? | Điều gì giúp bạn trở về với chính mình? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | RESET |
| CAT09_Q06 | CAT09 | 6 | space | What kind of physical space helps you feel calm? | Không gian vật lý nào giúp bạn thấy bình tĩnh? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | SPACE |
| CAT09_Q07 | CAT09 | 7 | relationships | How do peaceful relationships feel? | Những mối quan hệ bình yên mang cảm giác gì? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | RELATIONSHIPS |
| CAT09_Q08 | CAT09 | 8 | self_permission | What do you want to give yourself permission to do? | Bạn muốn cho phép bản thân điều gì? | MULTI_SELECT | Y | 3 | Add your own answer | Thêm câu trả lời của bạn | SELF_PERMISSION |
| CAT09_Q09 | CAT09 | 9 | first_action | What is one thing you can remove or soften today? | Một điều bạn có thể bỏ bớt hoặc làm nhẹ đi hôm nay là gì? | SINGLE_SELECT | Y | 1 | Add your own answer | Thêm câu trả lời của bạn | FIRST_ACTION |

## Sheet Suggested Answers

| Answer ID | Question ID | Order | Value Code | Label EN | Label VI | Active |
| --- | --- | --- | --- | --- | --- | --- |
| CAT01_Q01_A01 | CAT01_Q01 | 1 | SUPPORTIVE | Supportive | Biết hỗ trợ nhau | Y |
| CAT01_Q01_A02 | CAT01_Q01 | 2 | PLAYFUL | Playful | Vui vẻ | Y |
| CAT01_Q01_A03 | CAT01_Q01 | 3 | COMMITTED | Committed | Cam kết lâu dài | Y |
| CAT01_Q01_A04 | CAT01_Q01 | 4 | EMOTIONALLY_OPEN | Emotionally open | Cởi mở cảm xúc | Y |
| CAT01_Q01_A05 | CAT01_Q01 | 5 | GROWING_TOGETHER | Growing together | Cùng nhau phát triển | Y |
| CAT01_Q02_A01 | CAT01_Q02 | 1 | WE_TALK_OPENLY | We talk openly | Trò chuyện cởi mở | Y |
| CAT01_Q02_A02 | CAT01_Q02 | 2 | WE_MAKE_TIME_FOR_EACH_OTHER | We make time for each other | Dành thời gian cho nhau | Y |
| CAT01_Q02_A03 | CAT01_Q02 | 3 | WE_LAUGH_OFTEN | We laugh often | Thường xuyên cười cùng nhau | Y |
| CAT01_Q02_A04 | CAT01_Q02 | 4 | WE_SUPPORT_EACH_OTHER'S_GOALS | We support each other's goals | Ủng hộ mục tiêu của nhau | Y |
| CAT01_Q03_A01 | CAT01_Q03 | 1 | HONEST | Honest | Chân thành | Y |
| CAT01_Q03_A02 | CAT01_Q03 | 2 | KIND | Kind | Tử tế | Y |
| CAT01_Q03_A03 | CAT01_Q03 | 3 | SAFE | Safe | An toàn | Y |
| CAT01_Q03_A04 | CAT01_Q03 | 4 | CLEAR | Clear | Rõ ràng | Y |
| CAT01_Q03_A05 | CAT01_Q03 | 5 | RESPECTFUL | Respectful | Tôn trọng | Y |
| CAT01_Q04_A01 | CAT01_Q04 | 1 | QUIET_TIME_AT_HOME | Quiet time at home | Thời gian yên tĩnh ở nhà | Y |
| CAT01_Q04_A02 | CAT01_Q04 | 2 | TRAVEL | Travel | Du lịch | Y |
| CAT01_Q04_A03 | CAT01_Q04 | 3 | SHARED_HOBBIES | Shared hobbies | Sở thích chung | Y |
| CAT01_Q04_A04 | CAT01_Q04 | 4 | DATES | Dates | Những buổi hẹn | Y |
| CAT01_Q04_A05 | CAT01_Q04 | 5 | FAMILY_TIME | Family time | Thời gian với gia đình | Y |
| CAT01_Q05_A01 | CAT01_Q05 | 1 | EMOTIONAL_SUPPORT | Emotional support | Hỗ trợ cảm xúc | Y |
| CAT01_Q05_A02 | CAT01_Q05 | 2 | ENCOURAGEMENT | Encouragement | Khích lệ | Y |
| CAT01_Q05_A03 | CAT01_Q05 | 3 | PRACTICAL_SUPPORT | Practical support | Hỗ trợ thực tế | Y |
| CAT01_Q05_A04 | CAT01_Q05 | 4 | RESPECT_FOR_INDEPENDENCE | Respect for independence | Tôn trọng sự độc lập | Y |
| CAT01_Q06_A01 | CAT01_Q06 | 1 | PERSONAL_SPACE | Personal space | Không gian riêng | Y |
| CAT01_Q06_A02 | CAT01_Q06 | 2 | RESPECTFUL_CONFLICT | Respectful conflict | Tranh luận tôn trọng | Y |
| CAT01_Q06_A03 | CAT01_Q06 | 3 | TIME_FOR_FRIENDS_FAMILY | Time for friends/family | Thời gian cho bạn bè/gia đình | Y |
| CAT01_Q06_A04 | CAT01_Q06 | 4 | NO_CONTROLLING_BEHAVIOR | No controlling behavior | Không kiểm soát | Y |
| CAT01_Q07_A01 | CAT01_Q07 | 1 | STABLE_PARTNERSHIP | Stable partnership | Mối quan hệ ổn định | Y |
| CAT01_Q07_A02 | CAT01_Q07 | 2 | SHARED_HOME | Shared home | Cùng xây dựng tổ ấm | Y |
| CAT01_Q07_A03 | CAT01_Q07 | 3 | FAMILY | Family | Gia đình | Y |
| CAT01_Q07_A04 | CAT01_Q07 | 4 | SHARED_ADVENTURES | Shared adventures | Trải nghiệm chung | Y |
| CAT01_Q07_A05 | CAT01_Q07 | 5 | GROWING_OLD_TOGETHER | Growing old together | Đồng hành lâu dài | Y |
| CAT01_Q08_A01 | CAT01_Q08 | 1 | PRESENT | Present | Hiện diện | Y |
| CAT01_Q08_A02 | CAT01_Q08 | 2 | LOVING | Loving | Yêu thương | Y |
| CAT01_Q08_A03 | CAT01_Q08 | 3 | SECURE | Secure | Vững vàng | Y |
| CAT01_Q08_A04 | CAT01_Q08 | 4 | HONEST | Honest | Thành thật | Y |
| CAT01_Q08_A05 | CAT01_Q08 | 5 | INDEPENDENT | Independent | Độc lập | Y |
| CAT01_Q09_A01 | CAT01_Q09 | 1 | COMMUNICATE_CLEARLY | Communicate clearly | Giao tiếp rõ ràng | Y |
| CAT01_Q09_A02 | CAT01_Q09 | 2 | SHOW_APPRECIATION | Show appreciation | Thể hiện sự trân trọng | Y |
| CAT01_Q09_A03 | CAT01_Q09 | 3 | SET_A_BOUNDARY | Set a boundary | Thiết lập ranh giới | Y |
| CAT01_Q09_A04 | CAT01_Q09 | 4 | MAKE_QUALITY_TIME | Make quality time | Tạo thời gian chất lượng | Y |
| CAT02_Q01_A01 | CAT02_Q01 | 1 | BUILD_PRODUCTS | Build products | Xây dựng sản phẩm | Y |
| CAT02_Q01_A02 | CAT02_Q01 | 2 | CREATE | Create | Sáng tạo | Y |
| CAT02_Q01_A03 | CAT02_Q01 | 3 | LEAD | Lead | Dẫn dắt | Y |
| CAT02_Q01_A04 | CAT02_Q01 | 4 | SOLVE_PROBLEMS | Solve problems | Giải quyết vấn đề | Y |
| CAT02_Q01_A05 | CAT02_Q01 | 5 | HELP_PEOPLE | Help people | Giúp đỡ người khác | Y |
| CAT02_Q02_A01 | CAT02_Q02 | 1 | USEFUL_PRODUCTS | Useful products | Sản phẩm hữu ích | Y |
| CAT02_Q02_A02 | CAT02_Q02 | 2 | BETTER_EXPERIENCES | Better experiences | Trải nghiệm tốt hơn | Y |
| CAT02_Q02_A03 | CAT02_Q02 | 3 | GROWTH_FOR_A_TEAM | Growth for a team | Giúp đội ngũ phát triển | Y |
| CAT02_Q02_A04 | CAT02_Q02 | 4 | POSITIVE_CHANGE | Positive change | Tạo thay đổi tích cực | Y |
| CAT02_Q03_A01 | CAT02_Q03 | 1 | REMOTE | Remote | Từ xa | Y |
| CAT02_Q03_A02 | CAT02_Q03 | 2 | HYBRID | Hybrid | Linh hoạt | Y |
| CAT02_Q03_A03 | CAT02_Q03 | 3 | COLLABORATIVE_TEAM | Collaborative team | Đội ngũ hợp tác | Y |
| CAT02_Q03_A04 | CAT02_Q03 | 4 | INDEPENDENT | Independent | Tự chủ | Y |
| CAT02_Q03_A05 | CAT02_Q03 | 5 | INTERNATIONAL | International | Quốc tế | Y |
| CAT02_Q04_A01 | CAT02_Q04 | 1 | FLEXIBLE_HOURS | Flexible hours | Giờ linh hoạt | Y |
| CAT02_Q04_A02 | CAT02_Q04 | 2 | PREDICTABLE_SCHEDULE | Predictable schedule | Lịch ổn định | Y |
| CAT02_Q04_A03 | CAT02_Q04 | 3 | FOUR-DAY_WEEK | Four-day week | Tuần làm việc ngắn hơn | Y |
| CAT02_Q04_A04 | CAT02_Q04 | 4 | LOCATION_FREEDOM | Location freedom | Tự do địa điểm | Y |
| CAT02_Q05_A01 | CAT02_Q05 | 1 | STABLE_MONTHLY_INCOME | Stable monthly income | Thu nhập ổn định | Y |
| CAT02_Q05_A02 | CAT02_Q05 | 2 | HIGHER_SALARY | Higher salary | Mức lương cao hơn | Y |
| CAT02_Q05_A03 | CAT02_Q05 | 3 | MULTIPLE_INCOME_STREAMS | Multiple income streams | Nhiều nguồn thu | Y |
| CAT02_Q05_A04 | CAT02_Q05 | 4 | CUSTOM_AMOUNT | Custom amount | Nhập con số riêng | Y |
| CAT02_Q06_A01 | CAT02_Q06 | 1 | LEADERSHIP | Leadership | Lãnh đạo | Y |
| CAT02_Q06_A02 | CAT02_Q06 | 2 | COMMUNICATION | Communication | Giao tiếp | Y |
| CAT02_Q06_A03 | CAT02_Q06 | 3 | PRODUCT_THINKING | Product thinking | Tư duy sản phẩm | Y |
| CAT02_Q06_A04 | CAT02_Q06 | 4 | TECHNICAL_KNOWLEDGE | Technical knowledge | Kiến thức kỹ thuật | Y |
| CAT02_Q06_A05 | CAT02_Q06 | 5 | BUSINESS_STRATEGY | Business strategy | Chiến lược kinh doanh | Y |
| CAT02_Q07_A01 | CAT02_Q07 | 1 | TRUSTED_EXPERTISE | Trusted expertise | Được tin tưởng về chuyên môn | Y |
| CAT02_Q07_A02 | CAT02_Q07 | 2 | MEANINGFUL_OWNERSHIP | Meaningful ownership | Có quyền sở hữu công việc | Y |
| CAT02_Q07_A03 | CAT02_Q07 | 3 | FAIR_REWARDS | Fair rewards | Được ghi nhận xứng đáng | Y |
| CAT02_Q07_A04 | CAT02_Q07 | 4 | CAREER_PROGRESSION | Career progression | Phát triển sự nghiệp | Y |
| CAT02_Q08_A01 | CAT02_Q08 | 1 | PROUD | Proud | Tự hào | Y |
| CAT02_Q08_A02 | CAT02_Q08 | 2 | ENERGIZED | Energized | Có năng lượng | Y |
| CAT02_Q08_A03 | CAT02_Q08 | 3 | CALM | Calm | Bình tĩnh | Y |
| CAT02_Q08_A04 | CAT02_Q08 | 4 | USEFUL | Useful | Có ích | Y |
| CAT02_Q08_A05 | CAT02_Q08 | 5 | INSPIRED | Inspired | Có cảm hứng | Y |
| CAT02_Q09_A01 | CAT02_Q09 | 1 | LEARN_ONE_SKILL | Learn one skill | Học một kỹ năng | Y |
| CAT02_Q09_A02 | CAT02_Q09 | 2 | APPLY_FOR_AN_OPPORTUNITY | Apply for an opportunity | Ứng tuyển một cơ hội | Y |
| CAT02_Q09_A03 | CAT02_Q09 | 3 | FINISH_A_PORTFOLIO_PIECE | Finish a portfolio piece | Hoàn thiện một sản phẩm portfolio | Y |
| CAT02_Q09_A04 | CAT02_Q09 | 4 | TALK_TO_SOMEONE_IN_THE_FIELD | Talk to someone in the field | Trao đổi với người trong ngành | Y |
| CAT03_Q01_A01 | CAT03_Q01 | 1 | SECURITY | Security | An toàn | Y |
| CAT03_Q01_A02 | CAT03_Q01 | 2 | FREEDOM | Freedom | Tự do | Y |
| CAT03_Q01_A03 | CAT03_Q01 | 3 | CHOICE | Choice | Có nhiều lựa chọn | Y |
| CAT03_Q01_A04 | CAT03_Q01 | 4 | SUPPORTING_FAMILY | Supporting family | Chăm lo gia đình | Y |
| CAT03_Q01_A05 | CAT03_Q01 | 5 | CREATING_EXPERIENCES | Creating experiences | Tạo trải nghiệm | Y |
| CAT03_Q02_A01 | CAT03_Q02 | 1 | EMERGENCY_FUND | Emergency fund | Quỹ dự phòng | Y |
| CAT03_Q02_A02 | CAT03_Q02 | 2 | DEBT-FREE | Debt-free | Không nợ | Y |
| CAT03_Q02_A03 | CAT03_Q02 | 3 | MONTHLY_INCOME_GOAL | Monthly income goal | Mục tiêu thu nhập tháng | Y |
| CAT03_Q02_A04 | CAT03_Q02 | 4 | SAVINGS_GOAL | Savings goal | Mục tiêu tiết kiệm | Y |
| CAT03_Q02_A05 | CAT03_Q02 | 5 | INVESTMENT_GOAL | Investment goal | Mục tiêu đầu tư | Y |
| CAT03_Q03_A01 | CAT03_Q03 | 1 | REST_WITHOUT_WORRY | Rest without worry | Nghỉ ngơi không lo lắng | Y |
| CAT03_Q03_A02 | CAT03_Q03 | 2 | TRAVEL | Travel | Du lịch | Y |
| CAT03_Q03_A03 | CAT03_Q03 | 3 | OWN_A_HOME | Own a home | Có nhà | Y |
| CAT03_Q03_A04 | CAT03_Q03 | 4 | SUPPORT_LOVED_ONES | Support loved ones | Hỗ trợ người thân | Y |
| CAT03_Q03_A05 | CAT03_Q03 | 5 | CHOOSE_MEANINGFUL_WORK | Choose meaningful work | Chọn công việc có ý nghĩa | Y |
| CAT03_Q04_A01 | CAT03_Q04 | 1 | TRACK_SPENDING | Track spending | Theo dõi chi tiêu | Y |
| CAT03_Q04_A02 | CAT03_Q04 | 2 | SAVE_CONSISTENTLY | Save consistently | Tiết kiệm đều | Y |
| CAT03_Q04_A03 | CAT03_Q04 | 3 | LEARN_INVESTING_BASICS | Learn investing basics | Học kiến thức đầu tư cơ bản | Y |
| CAT03_Q04_A04 | CAT03_Q04 | 4 | SPEND_INTENTIONALLY | Spend intentionally | Chi tiêu có chủ đích | Y |
| CAT03_Q05_A01 | CAT03_Q05 | 1 | BUILD_VALUABLE_SKILLS | Build valuable skills | Xây kỹ năng có giá trị | Y |
| CAT03_Q05_A02 | CAT03_Q05 | 2 | NEGOTIATE_BETTER | Negotiate better | Đàm phán tốt hơn | Y |
| CAT03_Q05_A03 | CAT03_Q05 | 3 | CREATE_A_BUSINESS | Create a business | Xây doanh nghiệp | Y |
| CAT03_Q05_A04 | CAT03_Q05 | 4 | DEVELOP_ANOTHER_INCOME_STREAM | Develop another income stream | Tạo thêm nguồn thu | Y |
| CAT03_Q06_A01 | CAT03_Q06 | 1 | CALM | Calm | Bình tĩnh | Y |
| CAT03_Q06_A02 | CAT03_Q06 | 2 | CAPABLE | Capable | Có năng lực | Y |
| CAT03_Q06_A03 | CAT03_Q06 | 3 | IN_CONTROL | In control | Chủ động | Y |
| CAT03_Q06_A04 | CAT03_Q06 | 4 | GRATEFUL | Grateful | Biết ơn | Y |
| CAT03_Q06_A05 | CAT03_Q06 | 5 | PATIENT | Patient | Kiên nhẫn | Y |
| CAT03_Q07_A01 | CAT03_Q07 | 1 | SUPPORT_FAMILY | Support family | Hỗ trợ gia đình | Y |
| CAT03_Q07_A02 | CAT03_Q07 | 2 | DONATE | Donate | Đóng góp | Y |
| CAT03_Q07_A03 | CAT03_Q07 | 3 | TREAT_PEOPLE_I_LOVE | Treat people I love | Chăm sóc người mình yêu | Y |
| CAT03_Q07_A04 | CAT03_Q07 | 4 | SHARE_KNOWLEDGE_RESOURCES | Share knowledge/resources | Chia sẻ kiến thức/nguồn lực | Y |
| CAT03_Q08_A01 | CAT03_Q08 | 1 | BILLS_HANDLED | Bills handled | Các khoản chi được kiểm soát | Y |
| CAT03_Q08_A02 | CAT03_Q08 | 2 | SAVINGS_GROWING | Savings growing | Tiết kiệm tăng dần | Y |
| CAT03_Q08_A03 | CAT03_Q08 | 3 | NO_CONSTANT_MONEY_STRESS | No constant money stress | Không căng thẳng liên tục về tiền | Y |
| CAT03_Q08_A04 | CAT03_Q08 | 4 | CHOICES_FEEL_SPACIOUS | Choices feel spacious | Có nhiều lựa chọn hơn | Y |
| CAT03_Q09_A01 | CAT03_Q09 | 1 | REVIEW_BUDGET | Review budget | Xem lại ngân sách | Y |
| CAT03_Q09_A02 | CAT03_Q09 | 2 | AUTOMATE_SAVINGS | Automate savings | Tự động tiết kiệm | Y |
| CAT03_Q09_A03 | CAT03_Q09 | 3 | LEARN_ONE_CONCEPT | Learn one concept | Học một khái niệm | Y |
| CAT03_Q09_A04 | CAT03_Q09 | 4 | SET_A_REALISTIC_TARGET | Set a realistic target | Đặt mục tiêu thực tế | Y |
| CAT04_Q01_A01 | CAT04_Q01 | 1 | STEADY_ENERGY | Steady energy | Năng lượng ổn định | Y |
| CAT04_Q01_A02 | CAT04_Q01 | 2 | RESTFUL_SLEEP | Restful sleep | Ngủ ngon | Y |
| CAT04_Q01_A03 | CAT04_Q01 | 3 | COMFORTABLE_MOVEMENT | Comfortable movement | Vận động dễ chịu | Y |
| CAT04_Q01_A04 | CAT04_Q01 | 4 | CLEAR_MIND | Clear mind | Tinh thần sáng rõ | Y |
| CAT04_Q01_A05 | CAT04_Q01 | 5 | BALANCED_ROUTINE | Balanced routine | Nhịp sống cân bằng | Y |
| CAT04_Q02_A01 | CAT04_Q02 | 1 | WALKING | Walking | Đi bộ | Y |
| CAT04_Q02_A02 | CAT04_Q02 | 2 | RUNNING | Running | Chạy | Y |
| CAT04_Q02_A03 | CAT04_Q02 | 3 | YOGA | Yoga | Yoga | Y |
| CAT04_Q02_A04 | CAT04_Q02 | 4 | STRENGTH_TRAINING | Strength training | Tập sức mạnh | Y |
| CAT04_Q02_A05 | CAT04_Q02 | 5 | DANCE | Dance | Nhảy | Y |
| CAT04_Q03_A01 | CAT04_Q03 | 1 | CONSISTENT_BEDTIME | Consistent bedtime | Giờ ngủ ổn định | Y |
| CAT04_Q03_A02 | CAT04_Q03 | 2 | LESS_SCREEN_TIME | Less screen time | Ít màn hình hơn | Y |
| CAT04_Q03_A03 | CAT04_Q03 | 3 | CALM_WIND-DOWN | Calm wind-down | Thư giãn trước ngủ | Y |
| CAT04_Q03_A04 | CAT04_Q03 | 4 | ENOUGH_SLEEP | Enough sleep | Ngủ đủ | Y |
| CAT04_Q04_A01 | CAT04_Q04 | 1 | REGULAR_MEALS | Regular meals | Ăn đều | Y |
| CAT04_Q04_A02 | CAT04_Q04 | 2 | MORE_WHOLE_FOODS | More whole foods | Nhiều thực phẩm nguyên bản hơn | Y |
| CAT04_Q04_A03 | CAT04_Q04 | 3 | ENJOY_FOOD_WITHOUT_GUILT | Enjoy food without guilt | Ăn uống không tội lỗi | Y |
| CAT04_Q04_A04 | CAT04_Q04 | 4 | STAY_HYDRATED | Stay hydrated | Uống đủ nước | Y |
| CAT04_Q05_A01 | CAT04_Q05 | 1 | QUIET_TIME | Quiet time | Thời gian yên tĩnh | Y |
| CAT04_Q05_A02 | CAT04_Q05 | 2 | NATURE | Nature | Thiên nhiên | Y |
| CAT04_Q05_A03 | CAT04_Q05 | 3 | BREATHING | Breathing | Hít thở | Y |
| CAT04_Q05_A04 | CAT04_Q05 | 4 | TALKING_TO_SOMEONE | Talking to someone | Trò chuyện | Y |
| CAT04_Q05_A05 | CAT04_Q05 | 5 | REST | Rest | Nghỉ ngơi | Y |
| CAT04_Q06_A01 | CAT04_Q06 | 1 | CLEAN_SPACE | Clean space | Không gian sạch | Y |
| CAT04_Q06_A02 | CAT04_Q06 | 2 | SUNLIGHT | Sunlight | Ánh sáng tự nhiên | Y |
| CAT04_Q06_A03 | CAT04_Q06 | 3 | FRESH_AIR | Fresh air | Không khí trong lành | Y |
| CAT04_Q06_A04 | CAT04_Q06 | 4 | LESS_CLUTTER | Less clutter | Ít lộn xộn | Y |
| CAT04_Q07_A01 | CAT04_Q07 | 1 | RESPECT | Respect | Tôn trọng | Y |
| CAT04_Q07_A02 | CAT04_Q07 | 2 | PATIENCE | Patience | Kiên nhẫn | Y |
| CAT04_Q07_A03 | CAT04_Q07 | 3 | CARE | Care | Chăm sóc | Y |
| CAT04_Q07_A04 | CAT04_Q07 | 4 | ACCEPTANCE | Acceptance | Chấp nhận | Y |
| CAT04_Q07_A05 | CAT04_Q07 | 5 | STRENGTH | Strength | Sức mạnh | Y |
| CAT04_Q08_A01 | CAT04_Q08 | 1 | REMINDER | Reminder | Nhắc nhở | Y |
| CAT04_Q08_A02 | CAT04_Q08 | 2 | SIMPLE_ROUTINE | Simple routine | Routine đơn giản | Y |
| CAT04_Q08_A03 | CAT04_Q08 | 3 | FRIEND_PARTNER | Friend/partner | Bạn đồng hành | Y |
| CAT04_Q08_A04 | CAT04_Q08 | 4 | PROFESSIONAL_GUIDANCE_WHEN_NEEDED | Professional guidance when needed | Hướng dẫn chuyên môn khi cần | Y |
| CAT04_Q09_A01 | CAT04_Q09 | 1 | TAKE_A_WALK | Take a walk | Đi bộ | Y |
| CAT04_Q09_A02 | CAT04_Q09 | 2 | DRINK_WATER | Drink water | Uống nước | Y |
| CAT04_Q09_A03 | CAT04_Q09 | 3 | SLEEP_EARLIER | Sleep earlier | Ngủ sớm hơn | Y |
| CAT04_Q09_A04 | CAT04_Q09 | 4 | STRETCH | Stretch | Giãn cơ | Y |
| CAT04_Q09_A05 | CAT04_Q09 | 5 | TAKE_A_REAL_BREAK | Take a real break | Nghỉ thật sự | Y |
| CAT05_Q01_A01 | CAT05_Q01 | 1 | QUIET_NEIGHBORHOOD | Quiet neighborhood | Khu yên tĩnh | Y |
| CAT05_Q01_A02 | CAT05_Q01 | 2 | CITY_CENTER | City center | Trung tâm thành phố | Y |
| CAT05_Q01_A03 | CAT05_Q01 | 3 | NEAR_NATURE | Near nature | Gần thiên nhiên | Y |
| CAT05_Q01_A04 | CAT05_Q01 | 4 | NEAR_FAMILY | Near family | Gần gia đình | Y |
| CAT05_Q01_A05 | CAT05_Q01 | 5 | BY_THE_SEA | By the sea | Gần biển | Y |
| CAT05_Q02_A01 | CAT05_Q02 | 1 | BRIGHT_BEDROOM | Bright bedroom | Phòng ngủ sáng | Y |
| CAT05_Q02_A02 | CAT05_Q02 | 2 | COZY_LIVING_ROOM | Cozy living room | Phòng khách ấm cúng | Y |
| CAT05_Q02_A03 | CAT05_Q02 | 3 | READING_CORNER | Reading corner | Góc đọc sách | Y |
| CAT05_Q02_A04 | CAT05_Q02 | 4 | KITCHEN | Kitchen | Bếp | Y |
| CAT05_Q02_A05 | CAT05_Q02 | 5 | GARDEN_BALCONY | Garden/balcony | Vườn/ban công | Y |
| CAT05_Q03_A01 | CAT05_Q03 | 1 | WARM | Warm | Ấm áp | Y |
| CAT05_Q03_A02 | CAT05_Q03 | 2 | MINIMAL | Minimal | Tối giản | Y |
| CAT05_Q03_A03 | CAT05_Q03 | 3 | NATURAL | Natural | Tự nhiên | Y |
| CAT05_Q03_A04 | CAT05_Q03 | 4 | ELEGANT | Elegant | Thanh lịch | Y |
| CAT05_Q03_A05 | CAT05_Q03 | 5 | PLAYFUL | Playful | Vui tươi | Y |
| CAT05_Q04_A01 | CAT05_Q04 | 1 | COFFEE_TEA | Coffee/tea | Cà phê/trà | Y |
| CAT05_Q04_A02 | CAT05_Q04 | 2 | SUNLIGHT | Sunlight | Ánh nắng | Y |
| CAT05_Q04_A03 | CAT05_Q04 | 3 | MUSIC | Music | Âm nhạc | Y |
| CAT05_Q04_A04 | CAT05_Q04 | 4 | SLOW_BREAKFAST | Slow breakfast | Bữa sáng chậm rãi | Y |
| CAT05_Q04_A05 | CAT05_Q04 | 5 | QUIET_PLANNING | Quiet planning | Lên kế hoạch yên tĩnh | Y |
| CAT05_Q05_A01 | CAT05_Q05 | 1 | SOFT_LIGHTS | Soft lights | Ánh sáng dịu | Y |
| CAT05_Q05_A02 | CAT05_Q05 | 2 | DINNER_TOGETHER | Dinner together | Ăn tối cùng nhau | Y |
| CAT05_Q05_A03 | CAT05_Q05 | 3 | READING | Reading | Đọc sách | Y |
| CAT05_Q05_A04 | CAT05_Q05 | 4 | MOVIE_NIGHT | Movie night | Xem phim | Y |
| CAT05_Q05_A05 | CAT05_Q05 | 5 | QUIET_REST | Quiet rest | Nghỉ ngơi | Y |
| CAT05_Q06_A01 | CAT05_Q06 | 1 | PARTNER | Partner | Bạn đời | Y |
| CAT05_Q06_A02 | CAT05_Q06 | 2 | FAMILY | Family | Gia đình | Y |
| CAT05_Q06_A03 | CAT05_Q06 | 3 | PET | Pet | Thú cưng | Y |
| CAT05_Q06_A04 | CAT05_Q06 | 4 | JUST_ME | Just me | Một mình | Y |
| CAT05_Q06_A05 | CAT05_Q06 | 5 | FRIENDS_VISITING_OFTEN | Friends visiting often | Bạn bè thường ghé | Y |
| CAT05_Q07_A01 | CAT05_Q07 | 1 | REST | Rest | Nghỉ ngơi | Y |
| CAT05_Q07_A02 | CAT05_Q07 | 2 | WORK_FROM_HOME | Work from home | Làm việc tại nhà | Y |
| CAT05_Q07_A03 | CAT05_Q07 | 3 | HOST_LOVED_ONES | Host loved ones | Đón người thân | Y |
| CAT05_Q07_A04 | CAT05_Q07 | 4 | CREATE | Create | Sáng tạo | Y |
| CAT05_Q07_A05 | CAT05_Q07 | 5 | STAY_ORGANIZED | Stay organized | Sống ngăn nắp | Y |
| CAT05_Q08_A01 | CAT05_Q08 | 1 | SAFE | Safe | An toàn | Y |
| CAT05_Q08_A02 | CAT05_Q08 | 2 | PEACEFUL | Peaceful | Bình yên | Y |
| CAT05_Q08_A03 | CAT05_Q08 | 3 | WARM | Warm | Ấm áp | Y |
| CAT05_Q08_A04 | CAT05_Q08 | 4 | PROUD | Proud | Tự hào | Y |
| CAT05_Q08_A05 | CAT05_Q08 | 5 | GROUNDED | Grounded | Vững vàng | Y |
| CAT05_Q09_A01 | CAT05_Q09 | 1 | DECLUTTER_ONE_AREA | Declutter one area | Dọn một khu vực | Y |
| CAT05_Q09_A02 | CAT05_Q09 | 2 | ADD_A_PLANT | Add a plant | Thêm cây | Y |
| CAT05_Q09_A03 | CAT05_Q09 | 3 | CREATE_A_COZY_CORNER | Create a cozy corner | Tạo góc ấm cúng | Y |
| CAT05_Q09_A04 | CAT05_Q09 | 4 | SAVE_INSPIRATION_IMAGES | Save inspiration images | Lưu ảnh cảm hứng | Y |
| CAT06_Q01_A01 | CAT06_Q01 | 1 | BEACH | Beach | Biển | Y |
| CAT06_Q01_A02 | CAT06_Q01 | 2 | MOUNTAINS | Mountains | Núi | Y |
| CAT06_Q01_A03 | CAT06_Q01 | 3 | HISTORIC_CITIES | Historic cities | Thành phố lịch sử | Y |
| CAT06_Q01_A04 | CAT06_Q01 | 4 | NATURE | Nature | Thiên nhiên | Y |
| CAT06_Q01_A05 | CAT06_Q01 | 5 | BIG_CITIES | Big cities | Thành phố lớn | Y |
| CAT06_Q02_A01 | CAT06_Q02 | 1 | SLOW_TRAVEL | Slow travel | Đi chậm | Y |
| CAT06_Q02_A02 | CAT06_Q02 | 2 | ADVENTURE | Adventure | Phiêu lưu | Y |
| CAT06_Q02_A03 | CAT06_Q02 | 3 | LUXURY_&_REST | Luxury & rest | Nghỉ dưỡng | Y |
| CAT06_Q02_A04 | CAT06_Q02 | 4 | FOOD-FOCUSED | Food-focused | Ẩm thực | Y |
| CAT06_Q02_A05 | CAT06_Q02 | 5 | CULTURE-FOCUSED | Culture-focused | Văn hóa | Y |
| CAT06_Q03_A01 | CAT06_Q03 | 1 | SOLO | Solo | Một mình | Y |
| CAT06_Q03_A02 | CAT06_Q03 | 2 | PARTNER | Partner | Bạn đời | Y |
| CAT06_Q03_A03 | CAT06_Q03 | 3 | FAMILY | Family | Gia đình | Y |
| CAT06_Q03_A04 | CAT06_Q03 | 4 | FRIENDS | Friends | Bạn bè | Y |
| CAT06_Q04_A01 | CAT06_Q04 | 1 | ONE_BIG_TRIP_YEAR | One big trip/year | Một chuyến lớn/năm | Y |
| CAT06_Q04_A02 | CAT06_Q04 | 2 | SEVERAL_SHORT_TRIPS | Several short trips | Nhiều chuyến ngắn | Y |
| CAT06_Q04_A03 | CAT06_Q04 | 3 | WEEKEND_ESCAPES | Weekend escapes | Đi cuối tuần | Y |
| CAT06_Q04_A04 | CAT06_Q04 | 4 | LONG-TERM_TRAVEL | Long-term travel | Du lịch dài ngày | Y |
| CAT06_Q05_A01 | CAT06_Q05 | 1 | SUNRISE_SOMEWHERE_NEW | Sunrise somewhere new | Ngắm bình minh nơi mới | Y |
| CAT06_Q05_A02 | CAT06_Q05 | 2 | LOCAL_FOOD | Local food | Ăn món địa phương | Y |
| CAT06_Q05_A03 | CAT06_Q05 | 3 | NATURE_ADVENTURE | Nature adventure | Khám phá thiên nhiên | Y |
| CAT06_Q05_A04 | CAT06_Q05 | 4 | MEANINGFUL_CONVERSATIONS | Meaningful conversations | Những cuộc trò chuyện đáng nhớ | Y |
| CAT06_Q05_A05 | CAT06_Q05 | 5 | PHOTOGRAPHY | Photography | Chụp ảnh | Y |
| CAT06_Q06_A01 | CAT06_Q06 | 1 | SIMPLE_&_CLEAN | Simple & clean | Đơn giản sạch sẽ | Y |
| CAT06_Q06_A02 | CAT06_Q06 | 2 | BOUTIQUE | Boutique | Boutique | Y |
| CAT06_Q06_A03 | CAT06_Q06 | 3 | LUXURY | Luxury | Cao cấp | Y |
| CAT06_Q06_A04 | CAT06_Q06 | 4 | FLEXIBLE | Flexible | Linh hoạt | Y |
| CAT06_Q07_A01 | CAT06_Q07 | 1 | FREEDOM | Freedom | Tự do | Y |
| CAT06_Q07_A02 | CAT06_Q07 | 2 | LEARNING | Learning | Học hỏi | Y |
| CAT06_Q07_A03 | CAT06_Q07 | 3 | CONNECTION | Connection | Kết nối | Y |
| CAT06_Q07_A04 | CAT06_Q07 | 4 | REST | Rest | Nghỉ ngơi | Y |
| CAT06_Q07_A05 | CAT06_Q07 | 5 | WONDER | Wonder | Cảm giác kỳ diệu | Y |
| CAT06_Q08_A01 | CAT06_Q08 | 1 | CONFIDENCE | Confidence | Tự tin | Y |
| CAT06_Q08_A02 | CAT06_Q08 | 2 | STORIES | Stories | Câu chuyện | Y |
| CAT06_Q08_A03 | CAT06_Q08 | 3 | PHOTOS | Photos | Ảnh | Y |
| CAT06_Q08_A04 | CAT06_Q08 | 4 | NEW_PERSPECTIVE | New perspective | Góc nhìn mới | Y |
| CAT06_Q08_A05 | CAT06_Q08 | 5 | GRATITUDE | Gratitude | Biết ơn | Y |
| CAT06_Q09_A01 | CAT06_Q09 | 1 | CREATE_A_TRAVEL_FUND | Create a travel fund | Tạo quỹ du lịch | Y |
| CAT06_Q09_A02 | CAT06_Q09 | 2 | RESEARCH_A_DESTINATION | Research a destination | Tìm hiểu điểm đến | Y |
| CAT06_Q09_A03 | CAT06_Q09 | 3 | CHOOSE_DATES | Choose dates | Chọn ngày | Y |
| CAT06_Q09_A04 | CAT06_Q09 | 4 | SAVE_INSPIRATION | Save inspiration | Lưu cảm hứng | Y |
| CAT07_Q01_A01 | CAT07_Q01 | 1 | OPEN_CONVERSATIONS | Open conversations | Trò chuyện cởi mở | Y |
| CAT07_Q01_A02 | CAT07_Q01 | 2 | MORE_QUALITY_TIME | More quality time | Nhiều thời gian chất lượng | Y |
| CAT07_Q01_A03 | CAT07_Q01 | 3 | MUTUAL_SUPPORT | Mutual support | Hỗ trợ lẫn nhau | Y |
| CAT07_Q01_A04 | CAT07_Q01 | 4 | MORE_LAUGHTER | More laughter | Nhiều tiếng cười | Y |
| CAT07_Q02_A01 | CAT07_Q02 | 1 | WEEKLY_MEAL | Weekly meal | Bữa ăn hàng tuần | Y |
| CAT07_Q02_A02 | CAT07_Q02 | 2 | TRIPS_TOGETHER | Trips together | Du lịch cùng nhau | Y |
| CAT07_Q02_A03 | CAT07_Q02 | 3 | CELEBRATIONS | Celebrations | Những dịp kỷ niệm | Y |
| CAT07_Q02_A04 | CAT07_Q02 | 4 | CALLS_CHECK-INS | Calls/check-ins | Gọi hỏi thăm | Y |
| CAT07_Q03_A01 | CAT07_Q03 | 1 | WARM | Warm | Ấm áp | Y |
| CAT07_Q03_A02 | CAT07_Q03 | 2 | EASY | Easy | Thoải mái | Y |
| CAT07_Q03_A03 | CAT07_Q03 | 3 | SAFE | Safe | An toàn | Y |
| CAT07_Q03_A04 | CAT07_Q03 | 4 | FUN | Fun | Vui vẻ | Y |
| CAT07_Q03_A05 | CAT07_Q03 | 5 | CONNECTED | Connected | Gắn kết | Y |
| CAT07_Q04_A01 | CAT07_Q04 | 1 | LISTEN | Listen | Lắng nghe | Y |
| CAT07_Q04_A02 | CAT07_Q04 | 2 | ENCOURAGE | Encourage | Khích lệ | Y |
| CAT07_Q04_A03 | CAT07_Q04 | 3 | HELP_PRACTICALLY | Help practically | Giúp đỡ thực tế | Y |
| CAT07_Q04_A04 | CAT07_Q04 | 4 | RESPECT_CHOICES | Respect choices | Tôn trọng lựa chọn | Y |
| CAT07_Q05_A01 | CAT07_Q05 | 1 | RESPECT_PRIVACY | Respect privacy | Tôn trọng riêng tư | Y |
| CAT07_Q05_A02 | CAT07_Q05 | 2 | NO_GUILT-BASED_PRESSURE | No guilt-based pressure | Không gây áp lực bằng cảm giác tội lỗi | Y |
| CAT07_Q05_A03 | CAT07_Q05 | 3 | CLEAR_COMMUNICATION | Clear communication | Giao tiếp rõ ràng | Y |
| CAT07_Q05_A04 | CAT07_Q05 | 4 | TIME_FOR_SELF | Time for self | Có thời gian riêng | Y |
| CAT07_Q06_A01 | CAT07_Q06 | 1 | TRAVEL | Travel | Du lịch | Y |
| CAT07_Q06_A02 | CAT07_Q06 | 2 | FAMILY_DINNERS | Family dinners | Bữa cơm gia đình | Y |
| CAT07_Q06_A03 | CAT07_Q06 | 3 | PHOTOS | Photos | Chụp ảnh | Y |
| CAT07_Q06_A04 | CAT07_Q06 | 4 | CELEBRATIONS | Celebrations | Kỷ niệm | Y |
| CAT07_Q06_A05 | CAT07_Q06 | 5 | ORDINARY_PEACEFUL_DAYS | Ordinary peaceful days | Những ngày bình thường yên vui | Y |
| CAT07_Q07_A01 | CAT07_Q07 | 1 | PRESENT | Present | Hiện diện | Y |
| CAT07_Q07_A02 | CAT07_Q07 | 2 | PATIENT | Patient | Kiên nhẫn | Y |
| CAT07_Q07_A03 | CAT07_Q07 | 3 | SUPPORTIVE | Supportive | Biết hỗ trợ | Y |
| CAT07_Q07_A04 | CAT07_Q07 | 4 | HONEST | Honest | Thành thật | Y |
| CAT07_Q07_A05 | CAT07_Q07 | 5 | GRATEFUL | Grateful | Biết ơn | Y |
| CAT07_Q08_A01 | CAT07_Q08 | 1 | WE_STAY_CONNECTED | We stay connected | Luôn gắn kết | Y |
| CAT07_Q08_A02 | CAT07_Q08 | 2 | WE_RESPECT_EACH_OTHER | We respect each other | Tôn trọng nhau | Y |
| CAT07_Q08_A03 | CAT07_Q08 | 3 | WE_CREATE_A_SAFE_HOME | We create a safe home | Tạo tổ ấm an toàn | Y |
| CAT07_Q08_A04 | CAT07_Q08 | 4 | WE_GROW_TOGETHER | We grow together | Cùng phát triển | Y |
| CAT07_Q09_A01 | CAT07_Q09 | 1 | CALL_THEM | Call them | Gọi điện | Y |
| CAT07_Q09_A02 | CAT07_Q09 | 2 | SAY_THANK_YOU | Say thank you | Nói cảm ơn | Y |
| CAT07_Q09_A03 | CAT07_Q09 | 3 | SPEND_TIME_TOGETHER | Spend time together | Dành thời gian cùng nhau | Y |
| CAT07_Q09_A04 | CAT07_Q09 | 4 | HELP_WITH_SOMETHING | Help with something | Giúp một việc | Y |
| CAT08_Q01_A01 | CAT08_Q01 | 1 | CONFIDENT | Confident | Tự tin | Y |
| CAT08_Q01_A02 | CAT08_Q01 | 2 | DISCIPLINED | Disciplined | Kỷ luật | Y |
| CAT08_Q01_A03 | CAT08_Q01 | 3 | KIND | Kind | Tử tế | Y |
| CAT08_Q01_A04 | CAT08_Q01 | 4 | COURAGEOUS | Courageous | Dũng cảm | Y |
| CAT08_Q01_A05 | CAT08_Q01 | 5 | CALM | Calm | Điềm tĩnh | Y |
| CAT08_Q02_A01 | CAT08_Q02 | 1 | CLEARLY | Clearly | Rõ ràng | Y |
| CAT08_Q02_A02 | CAT08_Q02 | 2 | CONFIDENTLY | Confidently | Tự tin | Y |
| CAT08_Q02_A03 | CAT08_Q02 | 3 | HONESTLY | Honestly | Thành thật | Y |
| CAT08_Q02_A04 | CAT08_Q02 | 4 | WITHOUT_OVER-EXPLAINING | Without over-explaining | Không giải thích quá mức | Y |
| CAT08_Q02_A05 | CAT08_Q02 | 5 | WITH_WARMTH | With warmth | Ấm áp | Y |
| CAT08_Q03_A01 | CAT08_Q03 | 1 | SPEAK_UP | Speak up | Lên tiếng | Y |
| CAT08_Q03_A02 | CAT08_Q03 | 2 | TRY_SOMETHING_NEW | Try something new | Thử điều mới | Y |
| CAT08_Q03_A03 | CAT08_Q03 | 3 | APPLY_FOR_OPPORTUNITIES | Apply for opportunities | Nắm bắt cơ hội | Y |
| CAT08_Q03_A04 | CAT08_Q03 | 4 | CREATE_PUBLICLY | Create publicly | Chia sẻ sản phẩm/công việc | Y |
| CAT08_Q03_A05 | CAT08_Q03 | 5 | SET_BOUNDARIES | Set boundaries | Đặt ranh giới | Y |
| CAT08_Q04_A01 | CAT08_Q04 | 1 | COMMUNICATION | Communication | Giao tiếp | Y |
| CAT08_Q04_A02 | CAT08_Q04 | 2 | LEADERSHIP | Leadership | Lãnh đạo | Y |
| CAT08_Q04_A03 | CAT08_Q04 | 3 | LANGUAGE | Language | Ngoại ngữ | Y |
| CAT08_Q04_A04 | CAT08_Q04 | 4 | CREATIVE_SKILL | Creative skill | Kỹ năng sáng tạo | Y |
| CAT08_Q04_A05 | CAT08_Q04 | 5 | TECHNICAL_SKILL | Technical skill | Kỹ năng kỹ thuật | Y |
| CAT08_Q05_A01 | CAT08_Q05 | 1 | READ | Read | Đọc | Y |
| CAT08_Q05_A02 | CAT08_Q05 | 2 | EXERCISE | Exercise | Tập luyện | Y |
| CAT08_Q05_A03 | CAT08_Q05 | 3 | PLAN_MY_DAY | Plan my day | Lên kế hoạch | Y |
| CAT08_Q05_A04 | CAT08_Q05 | 4 | PRACTICE_A_SKILL | Practice a skill | Luyện kỹ năng | Y |
| CAT08_Q05_A05 | CAT08_Q05 | 5 | REFLECT | Reflect | Tự nhìn lại | Y |
| CAT08_Q06_A01 | CAT08_Q06 | 1 | ENCOURAGING | Encouraging | Khích lệ | Y |
| CAT08_Q06_A02 | CAT08_Q06 | 2 | REALISTIC | Realistic | Thực tế | Y |
| CAT08_Q06_A03 | CAT08_Q06 | 3 | COMPASSIONATE | Compassionate | Bao dung | Y |
| CAT08_Q06_A04 | CAT08_Q06 | 4 | STRONG | Strong | Vững vàng | Y |
| CAT08_Q06_A05 | CAT08_Q06 | 5 | CURIOUS | Curious | Tò mò | Y |
| CAT08_Q07_A01 | CAT08_Q07 | 1 | WORK | Work | Công việc | Y |
| CAT08_Q07_A02 | CAT08_Q07 | 2 | CAMERA_CONTENT | Camera/content | Trước camera/nội dung | Y |
| CAT08_Q07_A03 | CAT08_Q07 | 3 | RELATIONSHIPS | Relationships | Mối quan hệ | Y |
| CAT08_Q07_A04 | CAT08_Q07 | 4 | CREATIVE_PROJECTS | Creative projects | Dự án sáng tạo | Y |
| CAT08_Q07_A05 | CAT08_Q07 | 5 | COMMUNITY | Community | Cộng đồng | Y |
| CAT08_Q08_A01 | CAT08_Q08 | 1 | I_ACT_DESPITE_FEAR | I act despite fear | Hành động dù còn sợ | Y |
| CAT08_Q08_A02 | CAT08_Q08 | 2 | I_KEEP_PROMISES_TO_MYSELF | I keep promises to myself | Giữ lời với bản thân | Y |
| CAT08_Q08_A03 | CAT08_Q08 | 3 | I_RECOVER_FASTER | I recover faster | Phục hồi nhanh hơn | Y |
| CAT08_Q08_A04 | CAT08_Q08 | 4 | I_COMMUNICATE_DIRECTLY | I communicate directly | Giao tiếp trực tiếp | Y |
| CAT08_Q09_A01 | CAT08_Q09 | 1 | SHARE_AN_IDEA | Share an idea | Chia sẻ một ý tưởng | Y |
| CAT08_Q09_A02 | CAT08_Q09 | 2 | ASK_A_QUESTION | Ask a question | Đặt câu hỏi | Y |
| CAT08_Q09_A03 | CAT08_Q09 | 3 | PRACTICE_ON_CAMERA | Practice on camera | Luyện nói trước camera | Y |
| CAT08_Q09_A04 | CAT08_Q09 | 4 | FINISH_ONE_TASK | Finish one task | Hoàn thành một việc | Y |
| CAT09_Q01_A01 | CAT09_Q01 | 1 | LESS_RUSHING | Less rushing | Ít vội vã | Y |
| CAT09_Q01_A02 | CAT09_Q01 | 2 | CLEAR_BOUNDARIES | Clear boundaries | Ranh giới rõ | Y |
| CAT09_Q01_A03 | CAT09_Q01 | 3 | MORE_REST | More rest | Nghỉ ngơi nhiều hơn | Y |
| CAT09_Q01_A04 | CAT09_Q01 | 4 | QUIET_MIND | Quiet mind | Tâm trí yên hơn | Y |
| CAT09_Q01_A05 | CAT09_Q01 | 5 | SIMPLE_DAYS | Simple days | Những ngày đơn giản | Y |
| CAT09_Q02_A01 | CAT09_Q02 | 1 | NO_PHONE_FIRST | No phone first | Không xem điện thoại ngay | Y |
| CAT09_Q02_A02 | CAT09_Q02 | 2 | SLOW_BREAKFAST | Slow breakfast | Ăn sáng chậm | Y |
| CAT09_Q02_A03 | CAT09_Q02 | 3 | BREATHING | Breathing | Hít thở | Y |
| CAT09_Q02_A04 | CAT09_Q02 | 4 | SUNLIGHT | Sunlight | Ánh sáng | Y |
| CAT09_Q02_A05 | CAT09_Q02 | 5 | JOURNALING | Journaling | Viết journal | Y |
| CAT09_Q03_A01 | CAT09_Q03 | 1 | NOTIFICATIONS | Notifications | Thông báo | Y |
| CAT09_Q03_A02 | CAT09_Q03 | 2 | OVERCOMMITMENT | Overcommitment | Nhận quá nhiều việc | Y |
| CAT09_Q03_A03 | CAT09_Q03 | 3 | CLUTTER | Clutter | Bừa bộn | Y |
| CAT09_Q03_A04 | CAT09_Q03 | 4 | COMPARISON | Comparison | So sánh | Y |
| CAT09_Q03_A05 | CAT09_Q03 | 5 | CONSTANT_NEWS_SOCIAL_MEDIA | Constant news/social media | Tin tức/mạng xã hội liên tục | Y |
| CAT09_Q04_A01 | CAT09_Q04 | 1 | SAY_NO_EARLIER | Say no earlier | Nói không sớm hơn | Y |
| CAT09_Q04_A02 | CAT09_Q04 | 2 | LIMIT_SCREEN_TIME | Limit screen time | Giới hạn màn hình | Y |
| CAT09_Q04_A03 | CAT09_Q04 | 3 | PROTECT_SLEEP | Protect sleep | Bảo vệ giấc ngủ | Y |
| CAT09_Q04_A04 | CAT09_Q04 | 4 | AVOID_UNNECESSARY_CONFLICT | Avoid unnecessary conflict | Tránh xung đột không cần thiết | Y |
| CAT09_Q05_A01 | CAT09_Q05 | 1 | WALK | Walk | Đi bộ | Y |
| CAT09_Q05_A02 | CAT09_Q05 | 2 | MUSIC | Music | Âm nhạc | Y |
| CAT09_Q05_A03 | CAT09_Q05 | 3 | BREATHING | Breathing | Hít thở | Y |
| CAT09_Q05_A04 | CAT09_Q05 | 4 | WRITING | Writing | Viết | Y |
| CAT09_Q05_A05 | CAT09_Q05 | 5 | NATURE | Nature | Thiên nhiên | Y |
| CAT09_Q06_A01 | CAT09_Q06 | 1 | CLEAN | Clean | Gọn gàng | Y |
| CAT09_Q06_A02 | CAT09_Q06 | 2 | SOFT_LIGHT | Soft light | Ánh sáng dịu | Y |
| CAT09_Q06_A03 | CAT09_Q06 | 3 | PLANTS | Plants | Cây xanh | Y |
| CAT09_Q06_A04 | CAT09_Q06 | 4 | QUIET | Quiet | Yên tĩnh | Y |
| CAT09_Q06_A05 | CAT09_Q06 | 5 | MINIMAL | Minimal | Tối giản | Y |
| CAT09_Q07_A01 | CAT09_Q07 | 1 | SAFE | Safe | An toàn | Y |
| CAT09_Q07_A02 | CAT09_Q07 | 2 | NO_GUESSING_GAMES | No guessing games | Không phải đoán ý | Y |
| CAT09_Q07_A03 | CAT09_Q07 | 3 | RESPECTFUL | Respectful | Tôn trọng | Y |
| CAT09_Q07_A04 | CAT09_Q07 | 4 | MUTUAL | Mutual | Hai chiều | Y |
| CAT09_Q07_A05 | CAT09_Q07 | 5 | EASY_TO_COMMUNICATE | Easy to communicate | Dễ giao tiếp | Y |
| CAT09_Q08_A01 | CAT09_Q08 | 1 | REST | Rest | Nghỉ ngơi | Y |
| CAT09_Q08_A02 | CAT09_Q08 | 2 | CHANGE_MY_MIND | Change my mind | Đổi ý | Y |
| CAT09_Q08_A03 | CAT09_Q08 | 3 | MOVE_SLOWLY | Move slowly | Đi chậm | Y |
| CAT09_Q08_A04 | CAT09_Q08 | 4 | ASK_FOR_HELP | Ask for help | Nhờ giúp đỡ | Y |
| CAT09_Q08_A05 | CAT09_Q08 | 5 | LEAVE_WHAT_DRAINS_ME | Leave what drains me | Rời khỏi điều làm mình cạn năng lượng | Y |
| CAT09_Q09_A01 | CAT09_Q09 | 1 | MUTE_NOTIFICATIONS | Mute notifications | Tắt bớt thông báo | Y |
| CAT09_Q09_A02 | CAT09_Q09 | 2 | CANCEL_A_NONESSENTIAL_TASK | Cancel a nonessential task | Bỏ một việc không cần thiết | Y |
| CAT09_Q09_A03 | CAT09_Q09 | 3 | TAKE_10_QUIET_MINUTES | Take 10 quiet minutes | Dành 10 phút yên tĩnh | Y |
| CAT09_Q09_A04 | CAT09_Q09 | 4 | CLEAN_ONE_SPACE | Clean one space | Dọn một không gian | Y |

## Sheet Feelings

| Feeling ID | Code | Label EN | Label VI | Description EN | Description VI | Recommended Categories | Audio Tags | Sort | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| F01 | LOVED | Loved | Được yêu thương | I feel cared for and emotionally valued. | Tôi cảm thấy được yêu thương và trân trọng. | LOVE;FAMILY | warm;heart | 1 | ACTIVE |
| F02 | SAFE | Safe | An toàn | I feel emotionally or practically secure. | Tôi cảm thấy an toàn về cảm xúc hoặc thực tế. | LOVE;HOME;PEACE | soft;grounded | 2 | ACTIVE |
| F03 | CONNECTED | Connected | Gắn kết | I feel genuinely close to people or life around me. | Tôi cảm thấy kết nối chân thành với mọi người và cuộc sống. | LOVE;FAMILY | warm;gentle | 3 | ACTIVE |
| F04 | CONFIDENT | Confident | Tự tin | I trust my ability to handle what comes next. | Tôi tin vào khả năng xử lý điều tiếp theo. | CAREER;GROWTH | empowering;steady | 4 | ACTIVE |
| F05 | FREE | Free | Tự do | I have meaningful choice over my time and direction. | Tôi có quyền lựa chọn về thời gian và hướng đi. | CAREER;MONEY;TRAVEL | open;expansive | 5 | ACTIVE |
| F06 | INSPIRED | Inspired | Có cảm hứng | I feel energized by possibility and ideas. | Tôi có năng lượng từ những khả năng và ý tưởng mới. | CAREER;GROWTH | uplifting;bright | 6 | ACTIVE |
| F07 | SECURE | Secure | Vững vàng | My basic needs and plans feel supported. | Các nhu cầu và kế hoạch cơ bản của tôi được đảm bảo. | MONEY;CAREER | grounded;warm | 7 | ACTIVE |
| F08 | ABUNDANT | Abundant | Đủ đầy | I notice resources, opportunities and enoughness. | Tôi nhận ra nguồn lực, cơ hội và cảm giác đủ đầy. | MONEY | warm;expansive | 8 | ACTIVE |
| F09 | ENERGIZED | Energized | Tràn năng lượng | My body and mind feel ready to engage with life. | Cơ thể và tinh thần sẵn sàng tham gia vào cuộc sống. | HEALTH;TRAVEL | fresh;light | 9 | ACTIVE |
| F10 | STRONG | Strong | Mạnh mẽ | I feel capable and resilient. | Tôi cảm thấy có năng lực và kiên cường. | HEALTH;GROWTH | steady;empowering | 10 | ACTIVE |
| F11 | PEACEFUL | Peaceful | Bình yên | Life feels gentle and less rushed. | Cuộc sống nhẹ nhàng và ít vội vã hơn. | HOME;PEACE | calm;slow | 11 | ACTIVE |
| F12 | WARM | Warm | Ấm áp | My environment and relationships feel welcoming. | Không gian và mối quan hệ tạo cảm giác ấm áp. | HOME;FAMILY | warm;cozy | 12 | ACTIVE |
| F13 | CURIOUS | Curious | Tò mò | I feel open to new places, ideas and experiences. | Tôi cởi mở với nơi chốn, ý tưởng và trải nghiệm mới. | TRAVEL;GROWTH | open;playful | 13 | ACTIVE |
| F14 | ALIVE | Alive | Sống động | I feel present and engaged with life. | Tôi cảm thấy hiện diện và sống động. | TRAVEL;HEALTH | bright;rhythmic | 14 | ACTIVE |
| F15 | GRATEFUL | Grateful | Biết ơn | I notice and appreciate what is already meaningful. | Tôi nhận ra và trân trọng những gì đang có ý nghĩa. | FAMILY;MONEY;PEACE | warm;gentle | 15 | ACTIVE |
| F16 | PROUD | Proud | Tự hào | I recognize my effort, growth and contribution. | Tôi ghi nhận nỗ lực, sự trưởng thành và đóng góp của mình. | CAREER;GROWTH | uplifting;steady | 16 | ACTIVE |
| F17 | COURAGEOUS | Courageous | Dũng cảm | I act even when uncertainty is present. | Tôi vẫn hành động dù có sự không chắc chắn. | GROWTH | empowering;forward | 17 | ACTIVE |
| F18 | GROUNDED | Grounded | Vững tâm | I feel present, stable and not pulled in every direction. | Tôi hiện diện, ổn định và không bị kéo đi quá nhiều hướng. | PEACE;HOME | low;soft;grounded | 18 | ACTIVE |
| F19 | UNDERSTOOD | Understood | Thấu hiểu | I feel seen and understood without needing to explain everything. | Tôi cảm thấy được lắng nghe và thấu hiểu. | LOVE;FAMILY | warm;clear | 19 | ACTIVE |
| F20 | GENTLE | Gentle | Dịu dàng | I can move through this experience with softness and care. | Tôi có thể đi qua trải nghiệm này một cách dịu dàng và đầy quan tâm. | LOVE;HEALTH;PEACE | soft;calm | 20 | ACTIVE |
| F21 | TRUSTING | Trusting | Tin tưởng | I trust myself, the process and the people I choose. | Tôi tin vào bản thân, hành trình và những người mình lựa chọn. | LOVE;CAREER | steady;open | 21 | ACTIVE |
| F22 | RECOGNIZED | Recognized | Được ghi nhận | My effort and contribution are noticed and valued. | Nỗ lực và đóng góp của tôi được nhìn nhận và trân trọng. | CAREER;GROWTH | uplifting;steady | 22 | ACTIVE |
| F23 | FOCUSED | Focused | Tập trung | I can give my attention to what matters most. | Tôi có thể dành sự chú ý cho điều quan trọng nhất. | CAREER;GROWTH | clear;steady | 23 | ACTIVE |
| F24 | PROACTIVE | Proactive | Chủ động | I take practical steps toward what I value. | Tôi chủ động thực hiện những bước thiết thực cho điều mình coi trọng. | CAREER;MONEY | forward;grounded | 24 | ACTIVE |
| F25 | RELIEVED | Relieved | Nhẹ nhõm | I have space to breathe and release pressure. | Tôi có không gian để thở và buông bớt áp lực. | HEALTH;PEACE | light;calm | 25 | ACTIVE |
| F26 | BALANCED | Balanced | Cân bằng | My energy, time and needs are in a sustainable rhythm. | Năng lượng, thời gian và nhu cầu của tôi ở trong một nhịp bền vững. | HEALTH;HOME;PEACE | calm;steady | 26 | ACTIVE |
| F27 | CARED_FOR | Cared for | Được chăm sóc | I receive care and also make room to care for myself. | Tôi đón nhận sự chăm sóc và dành chỗ để tự chăm sóc mình. | HEALTH;FAMILY | nurturing;soft | 27 | ACTIVE |
| F28 | BELONGING | Belonging | Thuộc về | I feel at home with the people and places around me. | Tôi cảm thấy mình thuộc về những người và không gian quanh mình. | HOME;FAMILY | warm;grounded | 28 | ACTIVE |
| F29 | RESTED | Rested | Thư thái | My body and mind have room to slow down and restore. | Cơ thể và tâm trí của tôi có không gian để chậm lại và hồi phục. | HOME;TRAVEL;PEACE | slow;soft | 29 | ACTIVE |
| F30 | EXCITED | Excited | Hào hứng | I feel a bright sense of anticipation for what is ahead. | Tôi cảm thấy háo hức một cách tươi sáng về điều đang chờ phía trước. | TRAVEL;CAREER | bright;uplifting | 30 | ACTIVE |
| F31 | STEADY | Steady | Kiên định | I stay connected to my direction through small consistent steps. | Tôi gắn bó với hướng đi của mình qua những bước nhỏ đều đặn. | GROWTH;CAREER | steady;forward | 31 | ACTIVE |
| F32 | EXPANSIVE | Expansive | Rộng mở | I can see possibilities beyond my current limits. | Tôi có thể nhìn thấy những khả năng vượt ra ngoài giới hạn hiện tại. | MONEY;TRAVEL;GROWTH | open;expansive | 32 | ACTIVE |
| F33 | STILL | Still | Tĩnh tại | I feel quiet and present within myself. | Tôi cảm thấy tĩnh lặng và hiện diện bên trong mình. | PEACE;HOME | quiet;minimal | 33 | ACTIVE |
| F34 | REASSURED | Reassured | An tâm | I trust that my needs and next steps are supported. | Tôi an tâm rằng nhu cầu và những bước tiếp theo của mình được nâng đỡ. | MONEY;FAMILY | grounded;warm | 34 | ACTIVE |

## Sheet Statement Templates

| Template ID | Category ID | Type | Template EN | Template VI | Required Placeholders | Use When | Priority | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| ST01 | CAT01 | PRIMARY | I am creating a relationship that feels {feeling_1}, {feeling_2} and {communication_style}, where we {daily_connection}. | Tôi đang xây dựng một mối quan hệ {feeling_1}, {feeling_2} và {communication_style}, nơi chúng tôi {daily_connection}. | feeling_1;feeling_2;communication_style;daily_connection | default | 1 | ACTIVE |
| ST02 | CAT01 | SHORT | Love in my life feels {feeling_1}, mutual and safe. | Tình yêu trong cuộc sống của tôi mang cảm giác {feeling_1}, hai chiều và an toàn. | feeling_1 | compact card | 2 | ACTIVE |
| ST03 | CAT02 | PRIMARY | I am building meaningful work where I {work_type}, create {impact}, and have the freedom to work in a way that feels {work_feeling}. | Tôi đang xây dựng công việc có ý nghĩa, nơi tôi {work_type}, tạo ra {impact} và có sự tự do để làm việc theo cách khiến tôi cảm thấy {work_feeling}. | work_type;impact;work_feeling | default | 1 | ACTIVE |
| ST04 | CAT02 | SHORT | My work gives me growth, purpose and {feeling_1}. | Công việc mang cho tôi sự phát triển, ý nghĩa và {feeling_1}. | feeling_1 | compact card | 2 | ACTIVE |
| ST05 | CAT03 | PRIMARY | I am building a calm and capable relationship with money, working toward {target} so I can create more {meaning} in my life. | Tôi đang xây dựng mối quan hệ bình tĩnh và chủ động với tiền bạc, hướng tới {target} để tạo thêm {meaning} trong cuộc sống. | target;meaning | default | 1 | ACTIVE |
| ST06 | CAT03 | SHORT | I make grounded financial choices that support greater {feeling_1}. | Tôi đưa ra những lựa chọn tài chính thực tế để tạo thêm {feeling_1}. | feeling_1 | compact card | 2 | ACTIVE |
| ST07 | CAT04 | PRIMARY | I care for my wellbeing through {movement}, supportive rest and routines that help me feel {feeling_1} and {feeling_2}. | Tôi chăm sóc sức khỏe bằng {movement}, nghỉ ngơi phù hợp và những thói quen giúp tôi cảm thấy {feeling_1} và {feeling_2}. | movement;feeling_1;feeling_2 | default | 1 | ACTIVE |
| ST08 | CAT04 | SHORT | I treat my body with care, patience and respect. | Tôi đối xử với cơ thể bằng sự chăm sóc, kiên nhẫn và tôn trọng. |  | compact card | 2 | ACTIVE |
| ST09 | CAT05 | PRIMARY | My home is a {style} space where I can {function}, share life with {people}, and feel {feeling_1} when I walk through the door. | Ngôi nhà của tôi là một không gian {style}, nơi tôi có thể {function}, sẻ chia cuộc sống với {people} và cảm thấy {feeling_1} khi bước vào. | style;function;people;feeling_1 | default | 1 | ACTIVE |
| ST10 | CAT05 | SHORT | Home feels {feeling_1}, warm and deeply mine. | Nhà mang cảm giác {feeling_1}, ấm áp và thực sự thuộc về tôi. | feeling_1 | compact card | 2 | ACTIVE |
| ST11 | CAT06 | PRIMARY | I create space for {pace} experiences in {destination}, traveling in a way that gives me {meaning} and memories I will carry for years. | Tôi tạo không gian cho những trải nghiệm {pace} tại {destination}, du lịch theo cách mang lại {meaning} và những ký ức tôi sẽ mang theo nhiều năm. | pace;destination;meaning | default | 1 | ACTIVE |
| ST12 | CAT06 | SHORT | My life has room for wonder, discovery and {feeling_1}. | Cuộc sống của tôi có chỗ cho sự kỳ diệu, khám phá và {feeling_1}. | feeling_1 | compact card | 2 | ACTIVE |
| ST13 | CAT07 | PRIMARY | My family life is built on {connection}, healthy {boundaries}, and moments that help us feel {feeling_1} and connected. | Đời sống gia đình của tôi được xây trên {connection}, những {boundaries} lành mạnh và các khoảnh khắc giúp chúng tôi cảm thấy {feeling_1} và gắn kết. | connection;boundaries;feeling_1 | default | 1 | ACTIVE |
| ST14 | CAT07 | SHORT | We create a family life filled with respect, warmth and connection. | Chúng tôi tạo nên một đời sống gia đình đầy tôn trọng, ấm áp và gắn kết. |  | compact card | 2 | ACTIVE |
| ST15 | CAT08 | PRIMARY | I am becoming someone who is {future_self}, speaks {voice}, and takes brave action toward what matters. | Tôi đang trở thành một người {future_self}, thể hiện bản thân {voice} và dũng cảm hành động vì điều quan trọng. | future_self;voice | default | 1 | ACTIVE |
| ST16 | CAT08 | SHORT | I trust myself enough to take the next meaningful step. | Tôi đủ tin vào bản thân để thực hiện bước đi có ý nghĩa tiếp theo. |  | compact card | 2 | ACTIVE |
| ST17 | CAT09 | PRIMARY | I am creating a life with more {peace_meaning}, protected by {boundary}, and supported by simple ways to return to myself such as {reset}. | Tôi đang tạo một cuộc sống có nhiều {peace_meaning}, được bảo vệ bởi {boundary} và được nâng đỡ bởi những cách đơn giản để trở về với chính mình như {reset}. | peace_meaning;boundary;reset | default | 1 | ACTIVE |
| ST18 | CAT09 | SHORT | I give myself permission to move through life with more calm and space. | Tôi cho phép bản thân đi qua cuộc sống với nhiều bình tĩnh và khoảng thở hơn. |  | compact card | 2 | ACTIVE |

## Sheet Affirmations

| Affirmation ID | Category ID | Order | Text EN | Text VI | Feeling Tags | Use Case | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| CAT01_AF01 | CAT01 | 1 | I welcome relationships built on mutual respect and care. | Tôi đón nhận những mối quan hệ được xây trên sự tôn trọng và quan tâm lẫn nhau. | LOVED;SAFE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT01_AF02 | CAT01 | 2 | I can be loving without abandoning myself. | Tôi có thể yêu thương mà vẫn không bỏ quên chính mình. | LOVED;SAFE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT01_AF03 | CAT01 | 3 | Honest communication creates deeper connection. | Giao tiếp chân thành tạo nên kết nối sâu sắc hơn. | CONNECTED | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT01_AF04 | CAT01 | 4 | I deserve relationships where effort moves both ways. | Tôi xứng đáng với những mối quan hệ có sự vun đắp từ cả hai phía. | LOVED;SAFE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT01_AF05 | CAT01 | 5 | I make space for love that feels calm, clear and real. | Tôi tạo không gian cho tình yêu bình tĩnh, rõ ràng và chân thật. | PEACEFUL;LOVED | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT01_AF06 | CAT01 | 6 | I can set boundaries and remain kind. | Tôi có thể đặt ranh giới mà vẫn tử tế. | SAFE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT01_AF07 | CAT01 | 7 | I notice and appreciate the love already present in my life. | Tôi nhận ra và trân trọng tình yêu đã hiện diện trong cuộc sống. | GRATEFUL;LOVED | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT01_AF08 | CAT01 | 8 | I am learning to receive care as openly as I give it. | Tôi đang học cách đón nhận sự quan tâm cởi mở như cách tôi trao đi. | LOVED | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT02_AF01 | CAT02 | 1 | I am capable of creating meaningful work. | Tôi có khả năng tạo ra công việc có ý nghĩa. | CONFIDENT | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT02_AF02 | CAT02 | 2 | My skills grow when I practice them consistently. | Kỹ năng của tôi phát triển khi tôi luyện tập đều đặn. | CONFIDENT | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT02_AF03 | CAT02 | 3 | I can pursue ambition without abandoning balance. | Tôi có thể theo đuổi tham vọng mà vẫn giữ sự cân bằng. | FREE;PEACEFUL | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT02_AF04 | CAT02 | 4 | I bring useful ideas and thoughtful work to the table. | Tôi mang đến những ý tưởng hữu ích và công việc có chiều sâu. | PROUD | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT02_AF05 | CAT02 | 5 | I am allowed to want growth, recognition and fair rewards. | Tôi được phép mong muốn phát triển, được ghi nhận và nhận phần thưởng xứng đáng. | CONFIDENT;SECURE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT02_AF06 | CAT02 | 6 | I take the next step before I have every answer. | Tôi thực hiện bước tiếp theo trước khi có tất cả câu trả lời. | COURAGEOUS | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT02_AF07 | CAT02 | 7 | My career can evolve as I evolve. | Sự nghiệp của tôi có thể thay đổi cùng sự trưởng thành của tôi. | FREE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT02_AF08 | CAT02 | 8 | I am building work that supports the life I want to live. | Tôi đang xây dựng công việc hỗ trợ cuộc sống mà tôi muốn sống. | INSPIRED;FREE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT03_AF01 | CAT03 | 1 | I can learn to make calm and informed money decisions. | Tôi có thể học cách đưa ra quyết định tài chính bình tĩnh và có thông tin. | SECURE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT03_AF02 | CAT03 | 2 | Small consistent financial actions matter. | Những hành động tài chính nhỏ nhưng đều đặn đều có ý nghĩa. | SECURE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT03_AF03 | CAT03 | 3 | I am building greater financial stability step by step. | Tôi đang xây dựng sự ổn định tài chính từng bước. | SECURE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT03_AF04 | CAT03 | 4 | Money is a resource I can learn to manage with intention. | Tiền là một nguồn lực tôi có thể học cách quản lý có chủ đích. | ABUNDANT | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT03_AF05 | CAT03 | 5 | I can appreciate what I have while working toward more. | Tôi có thể trân trọng điều mình có đồng thời hướng tới nhiều hơn. | GRATEFUL;ABUNDANT | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT03_AF06 | CAT03 | 6 | My worth is not defined by a number in an account. | Giá trị của tôi không được quyết định bởi một con số trong tài khoản. | SAFE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT03_AF07 | CAT03 | 7 | I make space for opportunities and take grounded action. | Tôi mở lòng với cơ hội và hành động một cách thực tế. | ABUNDANT;COURAGEOUS | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT03_AF08 | CAT03 | 8 | Financial freedom grows from choices I repeat over time. | Tự do tài chính lớn lên từ những lựa chọn tôi lặp lại theo thời gian. | FREE;SECURE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT04_AF01 | CAT04 | 1 | My body deserves care, rest and respect. | Cơ thể tôi xứng đáng được chăm sóc, nghỉ ngơi và tôn trọng. | SAFE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT04_AF02 | CAT04 | 2 | I can support my wellbeing through small sustainable choices. | Tôi có thể nâng đỡ sức khỏe bằng những lựa chọn nhỏ và bền vững. | ENERGIZED | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT04_AF03 | CAT04 | 3 | Rest is part of caring for myself. | Nghỉ ngơi là một phần của việc chăm sóc bản thân. | PEACEFUL | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT04_AF04 | CAT04 | 4 | I listen to my body with patience rather than punishment. | Tôi lắng nghe cơ thể bằng sự kiên nhẫn thay vì trừng phạt. | SAFE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT04_AF05 | CAT04 | 5 | Movement can be something I enjoy, not something I owe. | Vận động có thể là điều tôi tận hưởng, không phải nghĩa vụ. | ALIVE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT04_AF06 | CAT04 | 6 | I am learning the routines that help me feel more steady. | Tôi đang học những thói quen giúp mình cảm thấy ổn định hơn. | GROUNDED | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT04_AF07 | CAT04 | 7 | I can ask for professional support when I need it. | Tôi có thể tìm kiếm hỗ trợ chuyên môn khi cần. | SAFE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT04_AF08 | CAT04 | 8 | My wellbeing is worth making room for. | Sức khỏe của tôi xứng đáng được dành chỗ trong cuộc sống. | STRONG | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT05_AF01 | CAT05 | 1 | I can create more peace in the space I have today. | Tôi có thể tạo thêm bình yên trong không gian mình đang có hôm nay. | PEACEFUL | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT05_AF02 | CAT05 | 2 | My home can support rest, connection and creativity. | Ngôi nhà của tôi có thể nâng đỡ nghỉ ngơi, kết nối và sáng tạo. | WARM | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT05_AF03 | CAT05 | 3 | I am allowed to want a home that feels deeply comfortable to me. | Tôi được phép mong muốn một ngôi nhà mang lại cảm giác thật sự thoải mái. | SAFE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT05_AF04 | CAT05 | 4 | Small changes can make my environment feel more like mine. | Những thay đổi nhỏ có thể khiến không gian giống với tôi hơn. | PROUD | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT05_AF05 | CAT05 | 5 | I notice the details that make a place feel warm. | Tôi nhận ra những chi tiết khiến một nơi trở nên ấm áp. | WARM | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT05_AF06 | CAT05 | 6 | Home is not only what it looks like, but how I feel inside it. | Nhà không chỉ là hình thức, mà còn là cảm giác của tôi khi ở trong đó. | SAFE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT05_AF07 | CAT05 | 7 | I make space for what matters and release what does not. | Tôi tạo chỗ cho điều quan trọng và buông bớt điều không cần thiết. | PEACEFUL | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT05_AF08 | CAT05 | 8 | I am building a home life that supports who I am becoming. | Tôi đang xây dựng đời sống tại nhà hỗ trợ con người tôi đang trở thành. | INSPIRED | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT06_AF01 | CAT06 | 1 | I make room in my life for meaningful experiences. | Tôi tạo không gian trong cuộc sống cho những trải nghiệm có ý nghĩa. | FREE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT06_AF02 | CAT06 | 2 | Curiosity can lead me somewhere beautiful. | Sự tò mò có thể đưa tôi tới những nơi đẹp đẽ. | CURIOUS | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT06_AF03 | CAT06 | 3 | I can plan responsibly and still leave room for adventure. | Tôi có thể lên kế hoạch có trách nhiệm mà vẫn dành chỗ cho phiêu lưu. | FREE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT06_AF04 | CAT06 | 4 | New places can teach me new ways of seeing. | Những nơi mới có thể dạy tôi những cách nhìn mới. | CURIOUS | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT06_AF05 | CAT06 | 5 | I am allowed to enjoy the life I am working hard to build. | Tôi được phép tận hưởng cuộc sống mà mình đang nỗ lực xây dựng. | ALIVE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT06_AF06 | CAT06 | 6 | I collect experiences, not only destinations. | Tôi tích lũy trải nghiệm, không chỉ điểm đến. | ALIVE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT06_AF07 | CAT06 | 7 | I can begin my next adventure with one small plan today. | Tôi có thể bắt đầu chuyến phiêu lưu tiếp theo bằng một kế hoạch nhỏ hôm nay. | COURAGEOUS | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT06_AF08 | CAT06 | 8 | I meet the world with openness and gratitude. | Tôi gặp gỡ thế giới bằng sự cởi mở và biết ơn. | GRATEFUL;CURIOUS | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT07_AF01 | CAT07 | 1 | I appreciate the people who make life feel like home. | Tôi trân trọng những người khiến cuộc sống có cảm giác như mái nhà. | GRATEFUL | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT07_AF02 | CAT07 | 2 | Healthy family connection can include both closeness and boundaries. | Kết nối gia đình lành mạnh có thể vừa gần gũi vừa có ranh giới. | SAFE;CONNECTED | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT07_AF03 | CAT07 | 3 | I can choose patience without silencing my needs. | Tôi có thể chọn sự kiên nhẫn mà không im lặng trước nhu cầu của mình. | SAFE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT07_AF04 | CAT07 | 4 | Ordinary time together can become meaningful memory. | Những khoảng thời gian bình thường bên nhau có thể trở thành ký ức ý nghĩa. | WARM | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT07_AF05 | CAT07 | 5 | I can contribute warmth without carrying everything alone. | Tôi có thể mang lại sự ấm áp mà không phải gánh mọi thứ một mình. | SAFE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT07_AF06 | CAT07 | 6 | Clear communication helps love feel safer. | Giao tiếp rõ ràng giúp tình yêu trở nên an toàn hơn. | CONNECTED | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT07_AF07 | CAT07 | 7 | I notice what is already good in my family life. | Tôi nhận ra những điều đã tốt đẹp trong đời sống gia đình. | GRATEFUL | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT07_AF08 | CAT07 | 8 | I help create the kind of family culture I want to live in. | Tôi góp phần tạo nên kiểu văn hóa gia đình mà mình muốn sống trong đó. | PROUD | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT08_AF01 | CAT08 | 1 | Confidence grows through action, not waiting. | Sự tự tin lớn lên qua hành động, không phải chờ đợi. | CONFIDENT | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT08_AF02 | CAT08 | 2 | I can be nervous and still speak clearly. | Tôi có thể hồi hộp mà vẫn nói rõ ràng. | COURAGEOUS | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT08_AF03 | CAT08 | 3 | I keep building evidence that I can trust myself. | Tôi tiếp tục tạo bằng chứng rằng mình có thể tin vào bản thân. | CONFIDENT | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT08_AF04 | CAT08 | 4 | I do not need perfection to be visible. | Tôi không cần hoàn hảo để dám xuất hiện. | COURAGEOUS | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT08_AF05 | CAT08 | 5 | My voice becomes stronger each time I use it. | Tiếng nói của tôi mạnh hơn mỗi lần tôi sử dụng. | CONFIDENT | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT08_AF06 | CAT08 | 6 | I am allowed to learn in public. | Tôi được phép học hỏi ngay cả khi người khác nhìn thấy. | COURAGEOUS | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT08_AF07 | CAT08 | 7 | I choose progress over hiding. | Tôi chọn tiến bộ thay vì trốn tránh. | PROUD | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT08_AF08 | CAT08 | 8 | I am becoming the person who follows through. | Tôi đang trở thành người biết thực hiện điều mình đã chọn. | PROUD | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT09_AF01 | CAT09 | 1 | I do not need to respond to everything immediately. | Tôi không cần phản hồi mọi thứ ngay lập tức. | PEACEFUL | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT09_AF02 | CAT09 | 2 | My peace deserves boundaries. | Sự bình yên của tôi xứng đáng được bảo vệ bằng ranh giới. | SAFE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT09_AF03 | CAT09 | 3 | I can move slowly without falling behind my own life. | Tôi có thể đi chậm mà không bị bỏ lại phía sau trong chính cuộc sống của mình. | PEACEFUL | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT09_AF04 | CAT09 | 4 | I release noise that does not deserve my attention. | Tôi buông bớt những nhiễu động không xứng đáng với sự chú ý của mình. | GROUNDED | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT09_AF05 | CAT09 | 5 | Rest can be productive for my whole life, even when it produces nothing. | Nghỉ ngơi có thể hữu ích cho cả cuộc sống, ngay cả khi không tạo ra sản phẩm nào. | PEACEFUL | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT09_AF06 | CAT09 | 6 | I can choose what gets access to my time and energy. | Tôi có thể lựa chọn điều gì được quyền tiếp cận thời gian và năng lượng của mình. | SAFE | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT09_AF07 | CAT09 | 7 | A quieter mind begins with one quieter moment. | Một tâm trí yên hơn bắt đầu từ một khoảnh khắc yên hơn. | GROUNDED | VISION_CARD;VISION_SESSION | ACTIVE |
| CAT09_AF08 | CAT09 | 8 | I return to myself gently. | Tôi nhẹ nhàng trở về với chính mình. | GROUNDED | VISION_CARD;VISION_SESSION | ACTIVE |

## Sheet Audio Mapping

| Mapping ID | Category ID | Category Scope | Recommended Audio | Audio Type | Duration Min | Mood Tags | Usage | Fallback | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| AM01 | CAT01 | ALL | Open Heart | SOUL_OWNED | 5 | warm;soft;heart | VISION_SESSION | Warm Light | ACTIVE |
| AM02 | CAT01 | ALL | Warm Light | SOUL_OWNED | 5 | safe;gentle | VISION_SESSION | Open Heart | ACTIVE |
| AM03 | CAT02 | ALL | Becoming | SOUL_OWNED | 5 | uplifting;steady | VISION_SESSION | Inner Strength | ACTIVE |
| AM04 | CAT02 | ALL | New Chapter | SOUL_OWNED | 5 | open;hopeful | VISION_SESSION | Becoming | ACTIVE |
| AM05 | CAT03 | ALL | Golden Flow | SOUL_OWNED | 5 | warm;grounded | VISION_SESSION | Quiet Confidence | ACTIVE |
| AM06 | CAT03 | ALL | Open Possibilities | SOUL_OWNED | 5 | expansive;warm | VISION_SESSION | Golden Flow | ACTIVE |
| AM07 | CAT04 | ALL | Gentle Vitality | SOUL_OWNED | 5 | fresh;light | VISION_SESSION | Morning Breath | ACTIVE |
| AM08 | CAT04 | ALL | Ocean Breath | SOUL_OWNED | 5 | calm;slow | VISION_SESSION | Gentle Vitality | ACTIVE |
| AM09 | CAT05 | ALL | Quiet Home | SOUL_OWNED | 5 | cozy;soft | VISION_SESSION | Rainy Evening | ACTIVE |
| AM10 | CAT05 | ALL | Warm Light | SOUL_OWNED | 5 | warm;cozy | VISION_SESSION | Quiet Home | ACTIVE |
| AM11 | CAT06 | ALL | Open Horizon | SOUL_OWNED | 5 | open;airy | VISION_SESSION | New Chapter | ACTIVE |
| AM12 | CAT06 | ALL | Bright Road | LICENSED | 5 | bright;rhythmic | VISION_SESSION | Open Horizon | ACTIVE |
| AM13 | CAT07 | ALL | Warm Light | SOUL_OWNED | 5 | warm;gentle | VISION_SESSION | Open Heart | ACTIVE |
| AM14 | CAT07 | ALL | Grateful Morning | SOUL_OWNED | 5 | warm;grateful | VISION_SESSION | Warm Light | ACTIVE |
| AM15 | CAT08 | ALL | Inner Strength | SOUL_OWNED | 5 | empowering;steady | VISION_SESSION | Becoming | ACTIVE |
| AM16 | CAT08 | ALL | New Chapter | SOUL_OWNED | 5 | forward;uplifting | VISION_SESSION | Inner Strength | ACTIVE |
| AM17 | CAT09 | ALL | Stillness | SOUL_OWNED | 5 | calm;minimal | VISION_SESSION | Quiet Morning | ACTIVE |
| AM18 | CAT09 | ALL | Slow Rain | SOUL_OWNED | 10 | soft;grounded | VISION_SESSION | Stillness | ACTIVE |

## Sheet External Mapping

| Map ID | Category ID | Platform | Content Type | Recommendation Theme EN | Recommendation Theme VI | Search/Editorial Keywords | Placement | Integration | Review Rule | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| EX01 | CAT01 | YOUTUBE | GUIDED_MEDITATION | Healthy love & secure relationship meditation | Thiền về tình yêu lành mạnh và mối quan hệ an toàn | healthy relationship meditation self love secure attachment | AFTER_VISION | Embed/deeplink official player only | Human editorial review; no promises of attracting a specific person | CANDIDATE |
| EX02 | CAT01 | SPOTIFY | PODCAST | Communication & healthy relationships | Giao tiếp và mối quan hệ lành mạnh | healthy relationship communication boundaries podcast | SOUL_PICKS | Deeplink/official embed | Review creator credibility and episode description | CANDIDATE |
| EX03 | CAT02 | YOUTUBE | GUIDED_VISUALIZATION | Future career self visualization | Hình dung phiên bản sự nghiệp tương lai | future self career visualization confidence guided | AFTER_VISION | Embed/deeplink | Avoid guaranteed career outcome claims | CANDIDATE |
| EX04 | CAT02 | SPOTIFY | PODCAST | Career confidence & growth mindset | Tự tin nghề nghiệp và growth mindset | career confidence growth mindset podcast | SOUL_PICKS | Deeplink | Prefer practical/action-oriented episodes | CANDIDATE |
| EX05 | CAT03 | YOUTUBE | MEDITATION | Calm money mindset meditation | Thiền mindset tài chính bình tĩnh | money mindset meditation abundance grounded | AFTER_VISION | Embed/deeplink | Exclude investment advice and guaranteed wealth claims | CANDIDATE |
| EX06 | CAT03 | SPOTIFY | PODCAST | Money habits & financial mindset | Thói quen tài chính và mindset tiền bạc | money habits financial mindset podcast | SOUL_PICKS | Deeplink | No personalized investment recommendations | CANDIDATE |
| EX07 | CAT04 | YOUTUBE | GUIDED_MEDITATION | Body kindness & wellbeing reset | Thiền chăm sóc cơ thể và cân bằng | body kindness wellbeing meditation rest | AFTER_VISION | Embed/deeplink | No cure/treatment claims | CANDIDATE |
| EX08 | CAT04 | SPOTIFY | PODCAST | Sustainable wellbeing habits | Thói quen sức khỏe bền vững | wellbeing habits sleep movement mindset podcast | SOUL_PICKS | Deeplink | General wellness only | CANDIDATE |
| EX09 | CAT05 | YOUTUBE | AMBIENCE | Cozy home ambience | Không gian âm thanh nhà ấm cúng | cozy home ambience rain fireplace | SOUL_PICKS | Official player/deeplink | Do not extract/rehost audio | CANDIDATE |
| EX10 | CAT05 | SPOTIFY | PODCAST | Home, simplicity & intentional living | Nhà cửa, tối giản và sống có chủ đích | intentional living home simplicity podcast | SOUL_PICKS | Deeplink | Editorial review | CANDIDATE |
| EX11 | CAT06 | YOUTUBE | VISUAL | Travel inspiration & mindful travel | Cảm hứng du lịch và mindful travel | mindful travel inspiration slow travel | SOUL_PICKS | Official player/deeplink | Avoid misleading travel footage/metadata | CANDIDATE |
| EX12 | CAT06 | SPOTIFY | PODCAST | Travel stories & perspective | Câu chuyện du lịch và góc nhìn mới | travel stories perspective podcast | SOUL_PICKS | Deeplink | Editorial review | CANDIDATE |
| EX13 | CAT07 | YOUTUBE | GUIDED_MEDITATION | Gratitude for family | Biết ơn gia đình | family gratitude meditation | AFTER_VISION | Embed/deeplink | Avoid guilt-based family messaging | CANDIDATE |
| EX14 | CAT07 | SPOTIFY | PODCAST | Family connection & boundaries | Kết nối gia đình và ranh giới | family connection boundaries podcast | SOUL_PICKS | Deeplink | Editorial review | CANDIDATE |
| EX15 | CAT08 | YOUTUBE | AFFIRMATION | Confidence affirmations | Affirmation tự tin | confidence affirmations self trust courage | AFTER_VISION | Official player/deeplink | Avoid exaggerated transformation claims | CANDIDATE |
| EX16 | CAT08 | SPOTIFY | PODCAST | Confidence, habits & growth mindset | Tự tin, thói quen và growth mindset | confidence habits mindset podcast | SOUL_PICKS | Deeplink | Prefer actionable episodes | CANDIDATE |
| EX17 | CAT09 | YOUTUBE | GUIDED_MEDITATION | Quiet mind & grounding meditation | Thiền tĩnh tâm và grounding | quiet mind grounding meditation calm | AFTER_VISION | Official player/deeplink | General wellness, not treatment | CANDIDATE |
| EX18 | CAT09 | SPOTIFY | PODCAST | Boundaries, rest & slowing down | Ranh giới, nghỉ ngơi và sống chậm | boundaries rest slow living podcast | SOUL_PICKS | Deeplink | Editorial review | CANDIDATE |

## Sheet Vision Sessions

| Session ID | Name EN | Name VI | Applicable Categories | Duration Min | Sequence | Audio Rule | CTA EN | CTA VI | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| VS01 | Quick Vision Reset | Vision nhanh | ALL | 3 | Breath 20s → 2 visions × 50s → affirmation 30s → action 30s | OWNED_OR_LICENSED_ONLY | What is one small step you can take today? | Một bước nhỏ bạn có thể làm hôm nay là gì? | ACTIVE |
| VS02 | Morning Future Self | Phiên bản tương lai buổi sáng | CAREER;GROWTH;MONEY | 5 | Breath 30s → 3 visions × 60s → future-self prompt 60s → action 30s | OWNED_OR_LICENSED_ONLY | Act like your future self for one small moment today. | Hôm nay hãy hành động như phiên bản tương lai của bạn trong một khoảnh khắc nhỏ. | ACTIVE |
| VS03 | Heart & Connection | Trái tim & Kết nối | LOVE;FAMILY | 5 | Breath 30s → relationship vision 90s → gratitude 60s → affirmation 60s → intention 60s | OWNED_OR_LICENSED_ONLY | What can you appreciate or communicate today? | Hôm nay bạn có thể trân trọng hoặc nói ra điều gì? | ACTIVE |
| VS04 | Abundance & Action | Đủ đầy & Hành động | MONEY;CAREER | 5 | Grounding 30s → vision 90s → gratitude 60s → statement 60s → grounded action 60s | OWNED_OR_LICENSED_ONLY | Choose one practical action that supports this vision. | Chọn một hành động thực tế hỗ trợ tầm nhìn này. | ACTIVE |
| VS05 | Wellbeing Vision | Tầm nhìn sức khỏe | HEALTH;PEACE | 5 | Breath 45s → body/wellbeing vision 90s → rest visualization 60s → affirmation 45s → action 60s | OWNED_OR_LICENSED_ONLY | What would caring for yourself look like today? | Hôm nay chăm sóc bản thân sẽ trông như thế nào? | ACTIVE |
| VS06 | Dream Home | Ngôi nhà trong mơ | HOME | 5 | Arrival breath 30s → exterior 60s → room details 90s → morning/evening feeling 90s → action 30s | OWNED_OR_LICENSED_ONLY | Bring one detail of this feeling into your current space. | Mang một chi tiết của cảm giác này vào không gian hiện tại. | ACTIVE |
| VS07 | Experience Reel | Cuộn trải nghiệm | TRAVEL | 5 | Breath 30s → destination 60s → experience scenes 120s → gratitude 60s → planning action 30s | OWNED_OR_LICENSED_ONLY | What is one practical step toward this experience? | Một bước thực tế hướng tới trải nghiệm này là gì? | ACTIVE |
| VS08 | Becoming Me | Trở thành tôi | GROWTH | 7 | Breath 45s → future-self scene 120s → difficult moment handled well 90s → affirmations 90s → brave action 75s | OWNED_OR_LICENSED_ONLY | What would this version of you do next? | Phiên bản này của bạn sẽ làm gì tiếp theo? | ACTIVE |
| VS09 | Quiet Mind | Tâm trí tĩnh | PEACE | 5 | Slow breath 60s → peaceful day 90s → boundaries 60s → release 60s → intention 30s | OWNED_OR_LICENSED_ONLY | What can you remove, delay or soften today? | Hôm nay bạn có thể bỏ bớt, trì hoãn hoặc làm nhẹ điều gì? | ACTIVE |

## Sheet CMS Import Notes

| Section | Rule / Enum | Implementation Notes |
| --- | --- | --- |
| Import order | 1 Categories → 2 Feelings → 3 Questions → 4 Answers → 5 Statement Templates → 6 Affirmations → 7 Audio → 8 External → 9 Sessions | Preserve IDs in this workbook as seed keys or map them to generated UUIDs. |
| Question types | MULTI_SELECT; SINGLE_SELECT; TEXT; NUMBER; SCALE | MVP dataset uses mainly MULTI_SELECT/SINGLE_SELECT; support custom answer for every guided question. |
| Vision creation | Category → Questions → Feelings → Statement → Image → Sound → Preview | Save draft after each step so users can resume. |
| Statement generation | Template placeholders | Map field_key values to selected labels/custom values. If a placeholder is empty, use short template or omit clause gracefully. |
| Feelings | Max 3 | Use feelings for display and statement language. Do not use them to select Vision Session audio. |
| Images | USER_UPLOAD; SOUL_LIBRARY | No need for AI image generation in MVP. Store attribution/license if Soul Library image is third-party licensed. |
| Audio | SOUL_OWNED; LICENSED | Select the category soundtrack from Audio Mapping. Only these may be used as Vision Session soundtrack. |
| External content | YOUTUBE; SPOTIFY | Curated cards only. Do not download, extract audio, or sync Spotify tracks to the Vision slideshow. |
| Localization | Translation table | Do not create title_vi/title_en columns in production schema; workbook is bilingual for editorial convenience only. |
| Health safety | General wellbeing | Do not imply treatment, diagnosis or guaranteed health outcomes. Encourage professional support where appropriate. |
| Money safety | General financial wellbeing | No personalized investment advice, guaranteed returns or 'manifest money' outcome claims. |
| Relationship safety | Healthy relationship framing | Do not imply a user can manifest/control a specific person's feelings or behavior. |
| Analytics | vision_creation_started; vision_question_answered; feeling_selected; statement_generated; vision_created; vision_session_started; vision_session_completed | Capture category_id, template_id, selected feelings and completion step. |
| Recommendation | Tag match for MVP | category + feeling → audio mapping; category → external curated slots. AI not required. |
| Music/frequency extension | Energy Taxonomy; Music Picks; Frequency Library; Energy Mapping | Add these after the original Vision content tables. |
| Energy selector | GRATITUDE;ABUNDANCE;SELF_LOVE;CONFIDENCE;CALM;LUCKY_GOOD_THINGS;FUTURE_SELF;RELEASE;LOVE_CONNECTION;ENERGY_LIFT | User can choose an energy; category default is only a suggestion. |
| Recommendation bundle | 1 native Soul/licensed audio + affirmation + optional external songs/frequency candidate | Native session soundtrack must remain owned/licensed. |
| External music | Spotify/YouTube | Deeplink or official embed only; never rip/download or sync Spotify audio into Vision slideshow. |
| Frequency copy | 432/528/888 Hz | Treat as spiritual/wellness taxonomy. Avoid claims that a frequency raises vibration in a scientifically proven, medical, or financial sense. |
| License archive | Asset URL + creator + download date + license snapshot/receipt | Required before any third-party native audio becomes ACTIVE. |

## Sheet Energy Taxonomy

| Energy ID | Code | Name EN | Name VI | Experience | Tags | Primary Use |
| --- | --- | --- | --- | --- | --- | --- |
| EN01 | GRATITUDE | Gratitude | Biết ơn | Warm, appreciative, grounded | gratitude;warm;gentle | Morning/evening gratitude rituals |
| EN02 | ABUNDANCE | Abundance | Đủ đầy | Expansive, prosperous, resource-aware | abundance;money;golden;expansive | Money/career/vision work |
| EN03 | SELF_LOVE | Self Love | Yêu bản thân | Soft, accepting, nurturing | self-love;soft;heart | Body, mirror, relationship practices |
| EN04 | CONFIDENCE | Confidence | Tự tin | Empowering, steady, forward | confidence;power;steady | Career/growth/visibility |
| EN05 | CALM | Calm | Thư giãn | Slow, quiet, spacious | calm;slow;minimal | Night, sleep, nervous-system-downshift style ambience |
| EN06 | LUCKY_GOOD_THINGS | Lucky / Good Things | May mắn / Điều tốt đẹp | Playful, optimistic, bright | lucky;optimistic;bright | High-vibe playlists, light manifestation mood |
| EN07 | FUTURE_SELF | Future Self | Phiên bản tương lai | Dreamy, aspirational, focused | future-self;dreamy;vision | Vision board/session |
| EN08 | RELEASE | Release & Reset | Buông bỏ & Làm mới | Grounded, spacious, resolving | release;reset;grounded | Mistakes, negativity, transition |
| EN09 | LOVE_CONNECTION | Love & Connection | Tình yêu & Kết nối | Warm, heart-centered, connected | love;heart;connection | Relationships/family |
| EN10 | ENERGY_LIFT | Energy Lift | Nâng năng lượng | Upbeat, radiant, motivating | energy;uplifting;bright | Morning/high-vibe usage |

## Sheet Music Picks

| Music ID | Platform | Link Type | Title | Artist / Curator | Energy Code | Vision Categories | Duration | URL | Integration | Editorial Status | Product Note |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| MP001 | SPOTIFY | TRACK | Money Up (Affirmations for Wealth) | Zii | ABUNDANCE | MONEY;CAREER | 2:55 | https://open.spotify.com/track/6osnOYfkIJJrQbOZE7PYon | DEEPLINK | VERIFIED | External only; do not sync as Vision Session soundtrack. |
| MP002 | SPOTIFY | TRACK | I Don't Chase, I Attract \| Manifestation Music for Love, Money & Abundance | Manifestation Music | ABUNDANCE | MONEY;LOVE;GROWTH | 4:40 | https://open.spotify.com/track/3MUI37dsu9Glbn8VweZ8oz | DEEPLINK | VERIFIED | External only; manifestation framing, no guaranteed outcome claims. |
| MP003 | SPOTIFY | TRACK | I Stay Lucky | Beautiful Chorus | LUCKY_GOOD_THINGS | GROWTH;TRAVEL;PEACE | 1:09 | https://open.spotify.com/track/3oRhjjiLO6rdZOPFz6cJhJ | DEEPLINK | VERIFIED | Use as high-vibe/lucky mood recommendation. |
| MP004 | SPOTIFY | TRACK | I Invite Ease & Joy | Geminelle, Deadwildin' | CALM | PEACE;GROWTH;HOME | 3:08 | https://open.spotify.com/track/0i6EOz53YsgC13IZGz8XTW | DEEPLINK | VERIFIED | Relaxed positive-energy recommendation. |
| MP005 | SPOTIFY | TRACK | I Forgive Myself & I Release | Geminelle | RELEASE | GROWTH;PEACE | 5:09 | https://open.spotify.com/track/3BVNTGnBRQvRGUj2mqvIsD | DEEPLINK | VERIFIED | Good for reset/release themes. |
| MP006 | SPOTIFY | TRACK | Eye Am That I Am | Toni Jones | CONFIDENCE | GROWTH;CAREER | 2:51 | https://open.spotify.com/track/0L64V8QedFzVPwIQH6PVw3 | DEEPLINK | VERIFIED | Self-concept/confidence recommendation. |
| MP007 | SPOTIFY | PLAYLIST_SOURCE | The Sound of High Vibe | The Sounds of Spotify | ENERGY_LIFT | ALL |  | https://open.spotify.com/embed/playlist/6GTqoouUghFknnAozSCGnj | PLAYLIST | VERIFIED | Discovery source for My Energy Is Infinite, Higher Self, Wealthy, Love Mantra, Self-Worth and others. |
| MP008 | SPOTIFY | PLAYLIST_SOURCE | Cassidy Affirmation Songs | Cassidy DeMos | SELF_LOVE | LOVE;GROWTH;PEACE |  | https://open.spotify.com/embed/playlist/4Yw2wfWhwPCtRNgE1uafHP | PLAYLIST | VERIFIED | Discovery source for i am enough., i attract abundance., Inner Peace and similar affirmation songs. |
| MP009 | SPOTIFY | PLAYLIST_SOURCE | manifesting walk 💫✨ | coley | LUCKY_GOOD_THINGS | CAREER;MONEY;GROWTH;TRAVEL |  | https://open.spotify.com/embed/playlist/3G515radkij7CGjRTXVBh2?theme=0 | PLAYLIST | VERIFIED | Discovery source for mainstream/high-energy manifestation playlist candidates. |
| MP010 | SPOTIFY | PLAYLIST_SOURCE | ABUNDANCE IS MINE | Kayla Belle | ABUNDANCE | MONEY;CAREER;GROWTH |  | https://open.spotify.com/embed/playlist/2ajxvzXzWVkS0mzHJDWk4e | PLAYLIST | VERIFIED | Discovery source for abundance/self-concept tracks; editorial review before activation. |
| MP011 | SPOTIFY | ARTIST_SOURCE | Geminelle — Top Tracks | Geminelle | FUTURE_SELF | GROWTH;CAREER;PEACE |  | https://open.spotify.com/embed/artist/4QNqXfa129rAppgBSQY4bq | ARTIST | VERIFIED | Discovery source for My Energy Is Infinite, My Success Is Inevitable, Everything I Need. |

## Sheet Frequency Library

| Frequency ID | Source | Usage Type | Title | Creator | Sound Type | Frequency Hz | Duration | Source URL | Energy Code | Recommended Use | Editorial Status | Safety / License Note |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| FR001 | PIXABAY | NATIVE_CANDIDATE | Manifestation Meditation | saavane | MANIFESTATION_AMBIENT |  | 3:33 | https://pixabay.com/music/search/manifestation/ | FUTURE_SELF | Vision/session ambience | REVIEW_LICENSE | Store asset-level license proof before production use. |
| FR002 | PIXABAY | NATIVE_CANDIDATE | 528hz | zenithhh | 528_HZ | 528 | 5:33 | https://pixabay.com/music/search/528hz/ | ABUNDANCE | Manifestation/vision ambience | REVIEW_LICENSE | Treat 528 Hz as a wellness/spiritual label, not a scientific efficacy claim. |
| FR003 | PIXABAY | NATIVE_CANDIDATE | 528Hz | The_Mountain | 528_HZ | 528 | 4:42 | https://pixabay.com/music/search/528hz/ | CALM | Meditation/relaxation | REVIEW_LICENSE | Asset-level license proof required. |
| FR004 | PIXABAY | NATIVE_CANDIDATE | 528Hz | leberch | 528_HZ | 528 | 5:46 | https://pixabay.com/music/search/528hz/ | CALM | Meditation/relaxation | REVIEW_LICENSE | Asset-level license proof required. |
| FR005 | PIXABAY | NATIVE_CANDIDATE | 528 Hz Meditation (Short, Pixabay) | Siarhei_Korbut | 528_HZ | 528 | 1:50 | https://pixabay.com/music/meditationspiritual-528-hz-meditation-short-pixabay-353343/ | CALM | Short reset/meditation | REVIEW_LICENSE | Page states free use under Pixabay Content License; keep download-date proof. |
| FR006 | PIXABAY | NATIVE_CANDIDATE | 432 +528 HZ release negative energy and fresh start | Shemsh | 432_528_HZ | 432;528 | 4:00 | https://pixabay.com/music/modern-classical-432-528-hz-release-negative-energy-and-fresh-start-324585/ | RELEASE | Reset/release ambience | REVIEW_LICENSE | Use neutral copy such as reset/relax; avoid claims about removing negative energy physiologically. |
| FR007 | PIXABAY | NATIVE_CANDIDATE | 888hz Airy Financial Manifestation | UniverseBella | 888_HZ | 888 | 2:52 | https://pixabay.com/music/search/manifestation%20music/ | ABUNDANCE | Money vision ambience | REVIEW_LICENSE | Spiritual category only; no promise of wealth outcomes. |
| FR008 | PIXABAY | NATIVE_CANDIDATE | 888hz Sacred Wealth Meditation | UniverseBella | 888_HZ | 888 | 4:00 | https://pixabay.com/music/search/manifesting%20meditation/ | ABUNDANCE | Abundance meditation | REVIEW_LICENSE | Asset-level review before use. |
| FR009 | PIXABAY | NATIVE_CANDIDATE | Twinkling Stars Soulful Ambience Soundscape | P4LASH | ETHEREAL |  | 6:24 | https://pixabay.com/music/search/manifesting%20meditation/ | FUTURE_SELF | Dreamy vision board ambience | REVIEW_LICENSE | Good non-frequency fallback for users who do not want spiritual frequency labels. |
| FR010 | PIXABAY | NATIVE_CANDIDATE | 432+220Hz | Shemsh | 432_HZ | 432;220 | 4:00 | https://pixabay.com/music/search/manifesting%20meditation/ | CALM | Grounding/relaxation | REVIEW_LICENSE | Frequency labels should remain descriptive only. |

## Sheet Energy Mapping

| Category ID | Category Code | Default Energy | Native Soul Audio | External Music IDs | Frequency IDs | Recommendation Logic |
| --- | --- | --- | --- | --- | --- | --- |
| CAT01 | LOVE | LOVE_CONNECTION | Open Heart | MP008 | FR009 | Love/connection; soft rather than 'attract a specific person' |
| CAT02 | CAREER | CONFIDENCE | Inner Strength | MP006 | FR009 | Confidence + future-self focus |
| CAT03 | MONEY | ABUNDANCE | Golden Flow | MP001;MP002;MP010 | FR002;FR007;FR008 | Offer abundance vibe plus grounded action prompt |
| CAT04 | HEALTH | CALM | Gentle Vitality | MP004 | FR003;FR005 | Wellbeing/relaxation only; no medical claims |
| CAT05 | HOME | CALM | Quiet Home | MP004 | FR009 | Warm, safe, grounded home atmosphere |
| CAT06 | TRAVEL | ENERGY_LIFT | Open Horizon | MP003;MP009 | FR009 | Bright, optimistic, exploratory energy |
| CAT07 | FAMILY | GRATITUDE | Warm Light | MP008 | FR009 | Connection + gratitude |
| CAT08 | GROWTH | CONFIDENCE | Inner Strength | MP006;MP007;MP011 | FR009 | Self-concept, courage, future self |
| CAT09 | PEACE | CALM | Stillness | MP004;MP005 | FR003;FR004;FR005;FR010 | Calm/release/grounding |
