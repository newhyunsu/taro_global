import 'dart:ui';

const String kBaseUrl = 'https://mogllotto.vercel.app/api';
// https://mogllotto.vercel.app/api-docs

/*
1. 메인 컬러 (배경 톤)
다크 네이비 (#0A0E2A, #101828)
👉 안정감, 신뢰, 프리미엄 감성

2. 포인트 컬러
메탈릭 골드 (#FFD700, #E6B800)
👉 당첨, 보상, 행운 상징

샴페인 골드 (#D4AF37) → 살짝 은은한 톤으로도 가능
3. 보조 컬러
화이트/실버 (#F5F5F5, #C0C0C0) → 텍스트 가독성, 보조 라인
에메랄드 그린 (#2ECC71) → “당첨” 버튼 강조용
*/
Color kPrimaryColor = '#101828'.toColor();
Color kSecondaryColor = '#FFD93D'.toColor();

extension ColorExtension on String {
  Color toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor"; // 투명도 추가
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
