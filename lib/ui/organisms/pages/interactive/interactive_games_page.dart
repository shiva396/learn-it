import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'package:learnit/ui/organisms/pages/interactive/paint_the_cat.dart';

class InteractiveGamesPage extends StatefulWidget {
  const InteractiveGamesPage({Key? key}) : super(key: key);

  @override
  _InteractiveGamesPageState createState() => _InteractiveGamesPageState();
}

class _InteractiveGamesPageState extends State<InteractiveGamesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<GameInfo> _filteredGames = [];
  String _selectedFilter = 'All';

  final List<GameInfo> _allGames = [
    GameInfo(
      title: 'Paint the Cat',
      description: 'Transform a cat using descriptive adjectives',
      grammarTopic: 'Adjective',
      previewIcon: Icons.pets,
      primaryColor: LColors.grammar,
      difficulty: 2,
      isAvailable: true,
      route: '/paint-the-cat',
    ),
    GameInfo(
      title: 'Magical Wardrobe',
      description: 'Dress up characters with descriptive clothing',
      grammarTopic: 'Adjective',
      previewIcon: Icons.checkroom,
      primaryColor: LColors.vocabulary,
      difficulty: 2,
      isAvailable: false,
      route: '/wardrobe-game',
    ),
    GameInfo(
      title: 'Weather Wizard',
      description: 'Create weather using descriptive adjectives',
      grammarTopic: 'Adjective',
      previewIcon: Icons.wb_sunny,
      primaryColor: LColors.exercises,
      difficulty: 3,
      isAvailable: false,
      route: '/weather-wizard',
    ),
    GameInfo(
      title: 'Verb Action Theater',
      description: 'Make characters perform actions and tenses',
      grammarTopic: 'Verb',
      previewIcon: Icons.theater_comedy,
      primaryColor: LColors.stories,
      difficulty: 3,
      isAvailable: false,
      route: '/verb-theater',
    ),
    GameInfo(
      title: 'Pronoun Planet',
      description: 'Replace nouns with pronouns in space',
      grammarTopic: 'Pronoun',
      previewIcon: Icons.rocket_launch,
      primaryColor: LColors.synectic,
      difficulty: 2,
      isAvailable: false,
      route: '/pronoun-planet',
    ),
    GameInfo(
      title: 'Noun Zoo Keeper',
      description: 'Categorize different types of nouns',
      grammarTopic: 'Noun',
      previewIcon: Icons.pets,
      primaryColor: LColors.success,
      difficulty: 1,
      isAvailable: false,
      route: '/noun-zoo',
    ),
    GameInfo(
      title: 'Adverb Race Track',
      description: 'Modify how race cars perform using adverbs',
      grammarTopic: 'Adverb',
      previewIcon: Icons.directions_car,
      primaryColor: LColors.warning,
      difficulty: 3,
      isAvailable: false,
      route: '/adverb-race',
    ),
    GameInfo(
      title: 'Preposition Adventure',
      description: 'Navigate through park using prepositions',
      grammarTopic: 'Preposition',
      previewIcon: Icons.map,
      primaryColor: LColors.highlight,
      difficulty: 2,
      isAvailable: false,
      route: '/preposition-adventure',
    ),
    GameInfo(
      title: 'Conjunction Train',
      description: 'Connect train cars using conjunctions',
      grammarTopic: 'Conjunction',
      previewIcon: Icons.train,
      primaryColor: LColors.error,
      difficulty: 3,
      isAvailable: false,
      route: '/conjunction-train',
    ),
    GameInfo(
      title: 'Emotion Studio',
      description: 'Express emotions using interjections',
      grammarTopic: 'Interjection',
      previewIcon: Icons.sentiment_very_satisfied,
      primaryColor: LColors.levelUp,
      difficulty: 1,
      isAvailable: false,
      route: '/emotion-studio',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredGames = _allGames;
  }

  void _filterGames(String query) {
    setState(() {
      if (query.isEmpty && _selectedFilter == 'All') {
        _filteredGames = _allGames;
      } else {
        _filteredGames =
            _allGames.where((game) {
              final matchesQuery =
                  query.isEmpty ||
                  game.title.toLowerCase().contains(query.toLowerCase()) ||
                  game.grammarTopic.toLowerCase().contains(query.toLowerCase());
              final matchesFilter =
                  _selectedFilter == 'All' ||
                  game.grammarTopic == _selectedFilter;
              return matchesQuery && matchesFilter;
            }).toList();
      }
    });
  }

  void _selectFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      _filterGames(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LColors.background,
      appBar: AppBar(
        backgroundColor: LColors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 29, 27, 27),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Interactive Games',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: _filterGames,
                  decoration: InputDecoration(
                    hintText: 'SEARCH GAMES',
                    hintStyle: const TextStyle(color: Colors.white),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: LColors.blue,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        [
                              'All',
                              'Adjective',
                              'Noun',
                              'Verb',
                              'Pronoun',
                              'Adverb',
                              'Preposition',
                              'Conjunction',
                              'Interjection',
                            ]
                            .map(
                              (filter) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(filter),
                                  selected: _selectedFilter == filter,
                                  onSelected: (_) => _selectFilter(filter),
                                  backgroundColor: Colors.white,
                                  selectedColor: LColors.blue,
                                  labelStyle: TextStyle(
                                    color:
                                        _selectedFilter == filter
                                            ? Colors.white
                                            : LColors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
          // Games Grid
          Expanded(
            child:
                _filteredGames.isEmpty ? _buildEmptyState() : _buildGamesGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No games found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildGamesGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _filteredGames.length,
        itemBuilder: (context, index) {
          final game = _filteredGames[index];
          return _GameCard(game: game, onTap: () => _navigateToGame(game));
        },
      ),
    );
  }

  void _navigateToGame(GameInfo game) {
    if (game.isAvailable) {
      if (game.route == '/paint-the-cat') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PaintTheCatPage()),
        );
      } else {
        Navigator.pushNamed(context, game.route);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${game.title} is coming soon!'),
          backgroundColor: LColors.blue,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _GameCard extends StatelessWidget {
  final GameInfo game;
  final VoidCallback onTap;

  const _GameCard({Key? key, required this.game, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                game.isAvailable
                    ? [Colors.white, Colors.grey[50]!]
                    : [Colors.grey[200]!, Colors.grey[300]!],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  game.isAvailable
                      ? LColors.blue.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Game Preview Section
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      game.primaryColor.withOpacity(0.3),
                      game.primaryColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    // Preview Icon/Illustration
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: game.primaryColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          game.previewIcon,
                          size: 40,
                          color: game.primaryColor,
                        ),
                      ),
                    ),
                    // Grammar Tag
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: game.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          game.grammarTopic,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Availability Overlay
                    if (!game.isAvailable)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Coming Soon',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Game Info Section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color:
                            game.isAvailable
                                ? Colors.black87
                                : Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      game.description,
                      style: TextStyle(
                        fontSize: 11,
                        color:
                            game.isAvailable
                                ? Colors.grey[600]
                                : Colors.grey[500],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // const Spacer(),
                    // Simple status indicator instead of stars and play button
                    // if (game.isAvailable)
                    //   Container(
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 6,
                    //       vertical: 2,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       color: LColors.success.withOpacity(0.1),
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //     child: Text(
                    //       'Available',
                    //       style: TextStyle(
                    //         fontSize: 9,
                    //         color: LColors.success,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameInfo {
  final String title;
  final String description;
  final String grammarTopic;
  final IconData previewIcon;
  final Color primaryColor;
  final int difficulty; // 1-3 stars
  final bool isAvailable;
  final String route;

  const GameInfo({
    required this.title,
    required this.description,
    required this.grammarTopic,
    required this.previewIcon,
    required this.primaryColor,
    required this.difficulty,
    required this.isAvailable,
    required this.route,
  });
}
