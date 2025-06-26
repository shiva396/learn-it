class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Master Grammar Effortlessly",
    image: "assets/images/onboard/onboard1.png",
    desc:
        "Learn grammar rules and concepts with ease through interactive lessons and examples.",
  ),
  OnboardingContents(
    title: "Track Your Learning Progress",
    image: "assets/images/onboard/onboard2.png",
    desc:
        "Stay motivated by tracking your progress as you complete topics and improve your skills.",
  ),
  OnboardingContents(
    title: "Engage with Interactive Content",
    image: "assets/images/onboard/onboard3.png",
    desc:
        "Explore engaging content, quizzes, and exercises designed to make learning fun and effective.",
  ),
];
