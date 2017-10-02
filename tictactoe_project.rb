require 'colorize'
require 'tty-prompt'

#=======================Variables=========================#
board = ['1', '2', '3', '4', '5', '6', '7', '8', '9']
player1 = 'X'
player2 = 'O'
@player1 = 'X'
@player2 = 'O'
@player1_colored = 'X'.green
@player2_colored = 'O'.red
@best_move = nil

#=======================Logic=========================#
def start(board , player1, player2)
  system 'clear'
  puts 'Welcome to Tic-Tac-Toe!'.yellow
  menu(board, player1, player2)
  prompt = TTY::Prompt.new
  loop do
    continue = prompt.select("Choose one:") do |menu|
      menu.choice 'Back to game menu', true
      menu.choice 'Exit', false
    end
    system 'clear'
    if continue
      start(new_board, player1, player2)
    else
      puts 'Thanks for playing! Hope to see you again!'
      exit
    end
  end
end

def menu(board, player1, player2)
  prompt = TTY::Prompt.new
  input = prompt.select("Choose a game mode:") do |menu|
    menu.choice 'Play against your friend', 1
    menu.choice 'Play against the computer (easy)', 2
    menu.choice 'Play against the computer (normal)', 3
    menu.choice 'Play against the computer (hard)', 4
    menu.choice 'Exit game', 5
  end
  if input == 1
    versus_human(board, player1, player2)
  elsif input == 2
    versus_ai_easy(board, player1, player2)
  elsif input == 3
    versus_ai_normal(board, player1, player2)
  elsif input == 4
    versus_ai_hard(board, player1, player2)
  else
    puts 'Thanks for playing! Hope to see you again!'
    exit
  end
end

def versus_human(board, player1, player2)
  system 'clear'
  puts "Player #{@player1_colored} starts first."
  loop do
    human_move(board, player1)
    break if game_over_with_display?(board, player1, "Player #{@player1_colored}")
    human_move(board, player2)
    break if game_over_with_display?(board, player2, "Player #{@player2_colored}")
  end
end

def versus_ai_easy(board, player1, player2)
  system 'clear'
  prompt = TTY::Prompt.new
  go_first = prompt.select('Do you want to go first?') do |menu|
    menu.choice 'Yes', true
    menu.choice 'No', false
  end
  system 'clear'
  if go_first
    puts "You are now player #{@player1_colored}."
    loop do
      human_move(board, player1)
      break if game_over_with_display?(board, player1, 'You')
      ai_easy_move(board, player2)
      break if game_over_with_display?(board, player2, 'Computer')
    end
  else
    ai_easy_move(board, player1)
    puts "You are now player #{@player2_colored}."
    loop do
      human_move(board, player2)
      break if game_over_with_display?(board, player2, 'You')
      ai_easy_move(board, player1)
      break if game_over_with_display?(board, player1, 'Computer')
    end
  end
end

def versus_ai_normal(board, player1, player2)
  system 'clear'
  prompt = TTY::Prompt.new
  go_first = prompt.select('Do you want to go first?') do |menu|
    menu.choice 'Yes', true
    menu.choice 'No', false
  end
  system 'clear'
  if go_first
    puts "You are now player #{@player1_colored}."
    loop do
      human_move(board, player1)
      break if game_over_with_display?(board, player1, 'You')
      ai_normal_move(board, player2, player1)
      break if game_over_with_display?(board, player2, 'Computer')
    end
  else
    ai_easy_move(board, player1)
    puts "You are now player #{@player2_colored}."
    loop do
      human_move(board, player2)
      break if game_over_with_display?(board, player2, 'You')
      ai_normal_move(board, player1, player2)
      break if game_over_with_display?(board, player1, 'Computer')
    end
  end
end

def versus_ai_hard(board, player1, player2)
  system 'clear'
  prompt = TTY::Prompt.new
  go_first = prompt.select('Do you want to go first?') do |menu|
    menu.choice 'Yes', true
    menu.choice 'No', false
  end
  system 'clear'
  if go_first
    puts "You are now player #{@player1_colored}."
    loop do
      human_move(board, player1)
      break if game_over_with_display?(board, player1, 'You')
      ai_hard_move(board, player2, player1)
      break if game_over_with_display?(board, player2, 'Computer')
    end
  else
    ai_easy_move(board, player1)
    puts "You are now player #{@player2_colored}."
    loop do
      human_move(board, player2)
      break if game_over_with_display?(board, player2, 'You')
      ai_hard_move(board, player1, player2)
      break if game_over_with_display?(board, player1, 'Computer')
    end
  end
end

def human_move(board, player)
  loop do
    print_board(board)
    puts "Player #{@player1_colored}, please enter your position [1-9] or 'm' to game menu" if player == 'X'
    puts "Player #{@player2_colored}, please enter your position [1-9] or 'm' to game menu" if player == 'O'
    input = gets.chomp
    system 'clear'
    if input == 'm'
      start(new_board, @player1, @player2)
    elsif input.to_i < 1 || input.to_i > 9
      system 'clear'
      puts 'Invalid position. Please choose another position'
    elsif board[input.to_i - 1] == 'X' || board[input.to_i - 1] == 'O'
      system 'clear'
      puts "Position #{input} has been taken. Please choose another position"
    else
      system 'clear'
      board[input.to_i - 1] = player
      puts "Player #{@player1_colored} has chosen position #{input}." if player == 'X'
      puts "Player #{@player2_colored} has chosen position #{input}." if player == 'O'
      break
    end
  end
end

def ai_easy_move(board, player)
  system 'clear'
  empty_positions = board.each_index.select { |i| board[i] != 'X' && board[i] != 'O' }
  computer_position = empty_positions.sample
  puts "Computer is thinking..."
  print_board(board)
  sleep 2
  system 'clear'
  puts "Computer has chosen position #{computer_position+1}."
  board[computer_position] = player
end

def ai_normal_move(board, ai, human)
  [true, true, false].sample ? ai_hard_move(board, ai, human) : ai_easy_move(board, ai)
end

def ai_hard_move(board, ai, human)
  system 'clear'
  String.disable_colorization = true
  minimax(board, ai, human)
  String.disable_colorization = false
  puts "Computer is thinking..."
  print_board(board)
  sleep 2
  system 'clear'
  puts "Computer has chosen position #{@best_move + 1}."
  board[@best_move] = ai
end

# Return true and print board & message if game is won or drawn
def game_over_with_display?(board, player, player_name)
  if win?(board, player)
    print_board(board)
    puts "#{player_name} won!"
    true
  elsif draw?(board)
    print_board(board)
    puts "It's a draw!"
    true
  else
    false
  end
end

# Return the minimax score
def get_score(board, ai, human)
  if win?(board, ai)
    10
  elsif win?(board, human)
    -10
  elsif draw?(board)
    0
  else
    nil
  end
end

# Calculate the best move using minimax algorithm
def minimax(board, ai, human, ai_turn=true)
  score = get_score(board, ai, human)
  return score unless score.nil?
  scores = []
  moves = []

  # ai's turn now
  empty_positions = board.each_index.select { |i| board[i] != 'X' && board[i] != 'O' }
  empty_positions.each do |move|
    board_after_move = board.dup
    board_after_move[move] = ai if ai_turn
    board_after_move[move] = human unless ai_turn
    # print_board(board_after_move)
    # puts
    score = minimax(board_after_move, ai, human, !ai_turn)
    scores.push(score)
    moves.push(move)
    # p "Scores: #{scores}"
    # p "Moves: #{moves}"
  end

  if ai_turn
    @best_move = moves[scores.index(scores.max)]
    return scores.max
  else
    return scores.min
  end
end

def win?(board, player)
  if (board[0] == player && board[1] == player && board[2] == player) ||
    (board[3] == player && board[4] == player && board[5] == player) ||
    (board[6] == player && board[7] == player && board[8] == player) ||
    (board[0] == player && board[3] == player && board[6] == player) ||
    (board[1] == player && board[4] == player && board[7] == player) ||
    (board[2] == player && board[5] == player && board[8] == player) ||
    (board[0] == player && board[4] == player && board[8] == player) ||
    (board[2] == player && board[4] == player && board[6] == player)
    # puts "Player #{player} has won!"
    return true
  end
  false
end

def draw?(board)
  board.each do |e|
    return false if e != 'X' && e != 'O'
  end
  # puts 'Draw!'
  true
end

def print_board(board)
  coloured_board = []
  board.each do |move|
    if move == 'X'
      coloured_board << 'X'.green
    elsif move == 'O'
      coloured_board << 'O'.red
    else
      coloured_board << move
    end
  end
  puts coloured_board[0..2].join(' | ')
  puts '----------'
  puts coloured_board[3..5].join(' | ')
  puts '----------'
  puts coloured_board[6..8].join(' | ')
end

def new_board
  %w[1 2 3 4 5 6 7 8 9]
end

#=======================Execution=========================#
start(board, player1, player2)
# test_board = %w[O 2 X X 5 6 X O O]
# print_board(test_board)
# minimax(test_board, 'X', 'O')
# puts "Best move: #{@best_move}"
# versus_ai_hard(board, player1, player2)
