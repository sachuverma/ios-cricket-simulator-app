//
//  MatchViewController.swift
//  cricket-simulator-application
//
//  Created by Sachin Verma on 02/07/25.
//

import UIKit

class MatchViewController: UIViewController {
    struct Score {
        var runs = 0
        var wickets = 0
        var balls = 0

        var oversText: String {
            return "\(balls / 6).\(balls % 6)"
        }
        var scoreText: String {
            return "\(runs)/\(wickets)"
        }
        var isInningsOver: Bool {
            return balls >= 12 || wickets >= 3
        }
    }

    enum Outcome: CaseIterable {
        case dot, one, two, three, four, six, out, wide

        var runValue: Int {
            switch self {
                case .dot: return 0
                case .one: return 1
                case .two: return 2
                case .three: return 3
                case .four: return 4
                case .six: return 6
                case .wide: return 1
                case .out: return 0
            }
        }

        var isExtraBall: Bool {
            return self == .wide
        }
        var isOut: Bool {
            return self == .out
        }
        var displayText: String {
            switch self {
            case .dot: return "Dot Ball"
            case .one: return "1 run"
            case .two: return "2 runs"
            case .three: return "3 runs"
            case .four: return "FOUR!"
            case .six: return "SIX!"
            case .out: return "WICKET!"
            case .wide: return "Wide Ball"
            }
        }
    }


    // Private Variables

    private let teams: [TeamDetail]
    private var currentBattingTeamIndex = 0
    private var scores = [Score(), Score()]
    private var isGameOver = false

    private let team1View = TeamScoreView()
    private let team2View = TeamScoreView()
    private let commentaryLabel = UILabel()

    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Play Next Ball", for: .normal)
        button.backgroundColor = Consts.greenColor
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        return button
    }()


    // Intialisation

    init(teams: [TeamDetail]) {
        self.teams = teams
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Consts.greenColor
        setupView()
    }

    private func setupView() {
        setupNavTitle()
        setupPlayButton()
        setupFirstTeamScoreView()
        setupSecondTeamScoreView()
        setupCommentaryLabel()
        updateScoreLabels()
    }

    private func setupNavTitle() {
        title = "Match Details"
    }

    private func setupFirstTeamScoreView() {
        view.addSubview(team1View)
        team1View.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            team1View.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            team1View.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            team1View.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            team1View.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15)
        ])
    }

    private func setupSecondTeamScoreView() {
        view.addSubview(team2View)
        team2View.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            team2View.topAnchor.constraint(equalTo: team1View.bottomAnchor),
            team2View.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            team2View.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            team2View.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15)
        ])
    }

    private func setupPlayButton() {
        view.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(playBall), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            playButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playButton.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func setupCommentaryLabel() {
        view.addSubview(commentaryLabel)
        commentaryLabel.translatesAutoresizingMaskIntoConstraints = false
        commentaryLabel.textAlignment = .center
        commentaryLabel.backgroundColor = .lightGray
        commentaryLabel.numberOfLines = 0
        commentaryLabel.text = "Match Begins"
        commentaryLabel.font = UIFont.boldSystemFont(ofSize: 50)

        NSLayoutConstraint.activate([
            commentaryLabel.topAnchor.constraint(equalTo: team2View.bottomAnchor),
            commentaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentaryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commentaryLabel.bottomAnchor.constraint(equalTo: playButton.topAnchor)
        ])
    }
    
    private func fetchRandomOutcome() -> Outcome {
        // Randomly select an outcome base on weightage given in this array.
        let weightedOutcomes: [(Outcome, Int)] = [
            (.dot, 25),
            (.one, 30),
            (.two, 15),
            (.three, 5),
            (.four, 10),
            (.six, 3),
            (.out, 4),
            (.wide, 8)
        ]

        // Select a random element from array of size 100.
        let pool = weightedOutcomes.flatMap { outcome, weight in
            Array(repeating: outcome, count: weight)
        }
        return pool.randomElement()!
    }

    @objc private func playBall() {
        guard !isGameOver else {
            return
        }

        let outcome = fetchRandomOutcome()
        let commentary = outcome.displayText

        // Apply runs.
        scores[currentBattingTeamIndex].runs += outcome.runValue

        // Handle Wicket.
        if outcome.isOut {
            scores[currentBattingTeamIndex].wickets += 1
        }

        // Only count legal deliveries for balls.
        if !outcome.isExtraBall {
            scores[currentBattingTeamIndex].balls += 1
        }

        // Update Labels.
        commentaryLabel.text = commentary
        updateScoreLabels()

        // Check if innings over.
        if scores[currentBattingTeamIndex].isInningsOver {
            if currentBattingTeamIndex == 0 {
                currentBattingTeamIndex = 1
                commentaryLabel.text = "\(teams[1].name) will bat now"
            } else {
                isGameOver = true
                declareResult()
            }
        }

        // Early win check for second team.
        if currentBattingTeamIndex == 1 && scores[1].runs > scores[0].runs {
            isGameOver = true
            declareResult()
            return
        }
    }

    private func updateScoreLabels() {
        team1View.setData(
            name: teams[0].name,
            score: scores[0].scoreText,
            overs: scores[0].oversText,
            isBatting: currentBattingTeamIndex == 0
        )
        
        team2View.setData(
            name: teams[1].name,
            score: scores[1].scoreText,
            overs: scores[1].oversText,
            isBatting: currentBattingTeamIndex == 1
        )
    }

    private func declareResult() {
        let score1 = scores[0].runs
        let score2 = scores[1].runs

        if score1 > score2 {
            commentaryLabel.text = "\(teams[0].name) wins by \(score1 - score2) runs!"
        } else if score2 > score1 {
            commentaryLabel.text = "\(teams[1].name) wins by \(3 - scores[1].wickets) wickets!"
        } else {
            commentaryLabel.text = "Match Tied!"
        }

        playButton.setTitle("Game Over", for: .normal)
        playButton.isEnabled = false
    }
}

