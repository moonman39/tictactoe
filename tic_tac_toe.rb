module Gameplay
  def game_intro
    puts "\nWelcome to Tic Tac Toe!\n"
    puts "\nPlease enter your moves one number at a time."
    puts "\nThe first number will be the row. The second number will be the column."
    puts "!IMPORTANT NOTE! Each row/column starts at 0 and ends at 2.  Enjoy!"
  end
  
  def get_moves(player)
    # Get a row and column entry from the player
    temporary_moves = []
    puts "\n#{player.name.capitalize}, enter the row"
    row = gets.chomp.to_i
    puts "\n#{player.name.capitalize}, enter the column"
    column = gets.chomp.to_i
    temporary_moves.push(row, column)
    # Check if the player entered an invalid entry
    if (row < 0 || row > 2) || (column < 0 || column > 2)
      puts "One of your entries was invalid. Please enter a number between 0 and 2 for each"
      get_moves(player)
    # Check if player entered a move that was already played
    elsif self.gameboard[temporary_moves[0]][temporary_moves[1]] != "_"
      puts "Sorry, that move was already entered"
      get_moves(player)
    else
      player.current_move.push(row, column)
    end
  end

  def update_board(game, player)
    game.gameboard[player.current_move[0]][player.current_move[1]] = player.icon
    player.moves.push(player.current_move)
    game.print_gameboard
    player.current_move = []
  end

  def win_check(game, player)
    match_count = 0
    game.winning_moves.each do |move_set|
      player.moves.each do |move|
        if move_set.include?(move)
          match_count += 1
          game.game_won = true if match_count == 3
        end
      end
      match_count = 0
    end
  end

  def play_game(player_one, player_two, game)
    loop do
      # Player One input, move entry, and win check
      game.get_moves(player_one)
      game.update_board(game, player_one)
      game.win_check(game, player_one)
      if game.game_won == true
        puts "\n#{player_one.name.capitalize} won!"
        break
      elsif game.catscratch(game) == 3
        puts "Catscratch! Its a tie"
        break
      end
      # Player Two input, move entry, and win check
      game.get_moves(player_two)
      game.update_board(game, player_two)
      game.win_check(game, player_two)
      if game.game_won == true
        puts "\n#{player_two.name.capitalize} won!"
        break
      elsif game.catscratch(game) == 3
        puts "Catscratch! Its a tie"
        break
      end
    end
  end

  def catscratch(game)
    catscratch = 0
    game.gameboard.each do |array|
      if array.none? { |board_piece| board_piece == "_"}
        catscratch += 1
      end
    end
    catscratch
  end
end




class Game
  include Gameplay

  attr_accessor :player_one, :player_two, :gameboard, :game_won, :winning_moves
  
  def initialize
    @gameboard = [["_", "_", "_"], ["_", "_", "_"], ["_", "_", "_"]]
    @winning_moves = [
      [[0, 0], [1, 0], [2, 0]],
      [[1, 0], [1, 1], [1, 2]],
      [[2, 0], [2, 1], [2, 2]],
      [[0, 0], [0, 1], [0, 2]],
      [[0, 1], [1, 1], [2, 1]],
      [[0, 2], [1, 2], [2, 2]],
      [[0, 0], [1, 1], [2, 2]],
      [[0, 2], [1, 1], [2, 0]],
    ]
    self.new_game
    @game_won = false
  end

  def new_game
    player_one = Player.new
    player_two = Player.new
    self.print_gameboard
    self.game_intro
    self.play_game(player_one, player_two, self)
  end

  def print_gameboard
    puts "\n"
    @gameboard.each { |array| puts array.join(" | ")}
  end
end




class Player
  attr_accessor :name, :current_move, :moves, :icon

  @@player_count = 0

  def initialize
    if @@player_count == 0
      puts "\nPlayer one, please enter your name"
      @name = gets.chomp.downcase
      @icon = "o"
    elsif @@player_count == 1
      puts "\nPlayer two, please enter your name"
      @name = gets.chomp.downcase
      @icon = "x"
    end
    @moves = []
    @current_move = []
    @@player_count += 1
  end
end

game = Game.new


