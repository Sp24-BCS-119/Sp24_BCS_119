import 'package:flutter/material.dart';

void main() {
  runApp(const DevPortfolioApp());
}

class DevPortfolioApp extends StatelessWidget {
  const DevPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DevProfileScreen(),
    );
  }
}

class DevProfileScreen extends StatelessWidget {
  const DevProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b1220),
      body: SafeArea(
        child: Column(
          children: [
            // 🔥 Header
            Container(
              padding: const EdgeInsets.all(20),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(
                      "https://via.placeholder.com/150",
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Muhammad Tehseen",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Cross-Platform App Engineer",
                          style: TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 📊 Quick Highlights
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  HighlightBox("Apps", "15"),
                  HighlightBox("Years", "2"),
                  HighlightBox("Rating", "4.8"),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 📄 Body
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xff111a2e),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // 👤 About
                    glassSection("About Me", const [
                      Text(
                        "Passionate mobile developer focused on building "
                        "high-performance Flutter applications with clean "
                        "architecture and modern UI/UX.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ]),

                    // 🧠 NEW SKILLS STRUCTURE
                    skillCategorySection(),

                    // 💼 Experience
                    glassSection("Experience", const [
                      InfoRow(
                        Icons.work_outline,
                        "Flutter Developer — 2023-Present",
                      ),
                      InfoRow(
                        Icons.rocket_launch,
                        "Delivered 10+ production apps",
                      ),
                      InfoRow(
                        Icons.groups,
                        "Worked with international clients",
                      ),
                    ]),

                    // 🎓 Education
                    glassSection("Education", const [
                      InfoRow(Icons.school_outlined, "BS Computer Science"),
                      InfoRow(
                        Icons.menu_book,
                        "Specialization in Mobile Computing",
                      ),
                    ]),

                    // ❤️ Interests
                    glassSection("Interests", const [
                      InfoRow(Icons.psychology, "Problem Solving"),
                      InfoRow(Icons.smartphone, "App UI Exploration"),
                      InfoRow(Icons.sports_esports, "Competitive Gaming"),
                    ]),

                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // 🚀 CTA
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff3b82f6),
        onPressed: () {},
        icon: const Icon(Icons.mail_outline),
        label: const Text("Contact Developer"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // 🔹 Glass Section
  static Widget glassSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  // 🔥 COMPLETELY NEW SKILLS UI
  static Widget skillCategorySection() {
    return glassSection("Technical Skills", const [
      SkillCategory(
        title: "Mobile Development",
        skills: [
          SkillChip("Flutter", level: "Advanced"),
          SkillChip("Dart", level: "Advanced"),
          SkillChip("Android Basics", level: "Intermediate"),
        ],
      ),
      SizedBox(height: 14),
      SkillCategory(
        title: "Backend & Services",
        skills: [
          SkillChip("Firebase", level: "Advanced"),
          SkillChip("REST APIs", level: "Advanced"),
          SkillChip("Node.js", level: "Beginner"),
        ],
      ),
      SizedBox(height: 14),
      SkillCategory(
        title: "Tools & Workflow",
        skills: [
          SkillChip("Git & GitHub", level: "Advanced"),
          SkillChip("VS Code", level: "Advanced"),
          SkillChip("Figma", level: "Intermediate"),
        ],
      ),
    ]);
  }
}

// 🔹 Highlight Box
class HighlightBox extends StatelessWidget {
  final String label;
  final String value;

  const HighlightBox(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xff3b82f6),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.white54)),
      ],
    );
  }
}

// 🔹 Info Row
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoRow(this.icon, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xff3b82f6), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
}

// 🔥 Skill Category
class SkillCategory extends StatelessWidget {
  final String title;
  final List<Widget> skills;

  const SkillCategory({super.key, required this.title, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: skills),
      ],
    );
  }
}

// 🔥 Skill Chip with Level
class SkillChip extends StatelessWidget {
  final String name;
  final String level;

  const SkillChip(this.name, {required this.level, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xff1f2a44),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        "$name • $level",
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }
}
