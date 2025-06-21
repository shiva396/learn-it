class JumbledWordQuestion {
  final String id;
  final String questionLabel;
  final List<String> options;
  final int correctIndex;

  JumbledWordQuestion({
    required this.id,
    required this.questionLabel,
    required this.options,
    required this.correctIndex,
  });
}

final List<JumbledWordQuestion> jumbledQuestions = [
  JumbledWordQuestion(
    id: '1',
    questionLabel: 'Jumbled Word: __________',
    options: ['BLATO', 'BATLO', 'BOLAT', 'BLOAT'],
    correctIndex: 3,
  ),
  JumbledWordQuestion(
    id: '2',
    questionLabel: 'Jumbled Word: __________',
    options: ['KYE', 'KEY', 'EKY', 'YKE'],
    correctIndex: 1,
  ),
  JumbledWordQuestion(
    id: '3',
    questionLabel: 'Jumbled Word: __________',
    options: ['SIDE', 'DISE', 'ISDE', 'ESDI'],
    correctIndex: 0,
  ),
  JumbledWordQuestion(
    id: '4',
    questionLabel: 'Jumbled Word: __________',
    options: ['PEACH', 'AHCPE', 'CAPHE', 'HCAEP'],
    correctIndex: 0,
  ),
  JumbledWordQuestion(
    id: '5',
    questionLabel: 'Jumbled Word: _____________',
    options: ['COLOUR', 'RUCOLO', 'OCULOR', 'LORUCO'],
    correctIndex: 0,
  ),
  JumbledWordQuestion(
    id: '6',
    questionLabel: 'Jumbled Word: ____________',
    options: ['PYRAMID', 'DRIPAMY', 'MAYIDRP', 'MIRYPAD'],
    correctIndex: 0,
  ),
  JumbledWordQuestion(
    id: '7',
    questionLabel: 'Jumbled Word: ______________',
    options: ['ROWND', 'WORDN', 'DROWN', 'WDRON'],
    correctIndex: 2,
  ),
  JumbledWordQuestion(
    id: '8',
    questionLabel: 'Jumbled Word: _____________',
    options: ['HOBBY', 'BYOHB', 'BYOHB', 'BOYHB'],
    correctIndex: 0,
  ),
  JumbledWordQuestion(
    id: '9',
    questionLabel: 'Jumbled Word: _____________',
    options: ['CBALK', 'BKCAL', 'CBLAK', 'BLACK'],
    correctIndex: 3,
  ),
];
