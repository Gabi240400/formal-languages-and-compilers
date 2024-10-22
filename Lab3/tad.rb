require_relative 'state'
require 'D:\Facultate\An3\Sem1\LFTC\Lab4\grammar.rb'

class TAD
  # states - Array
  # alphabet - Array
  # possible_moves - Hash
  attr_accessor :states, :alphabet, :possible_moves

  def initialize(states, alphabet, possible_moves)
    @states = states
    @alphabet = alphabet
    @possible_moves = possible_moves
  end

  # returns a String with the name of the initial state
  def get_initial_state
    @states.each do |state|
      if state.initial == true
        return state.name
      end
    end
  end

  # returns an Array with the names of the final states
  def get_final_states
    final_states = Array[]
    @states.each do |state|
      final_states.push(state.name) if state.final == true
    end
    final_states
  end

  # returns Boolean
  def is_final_state(state)
    return self.get_final_states.include?(state)
  end

  # prints all possible moves
  def possible_moves_to_s
    puts 'Tranzitiile sunt:'
    @possible_moves.each do |part1, part2|
      move = "(#{part1}) -> #{part2}"
      puts move
    end
  end

  # prints a TAD object
  def to_s
    puts 'Alfabetul este: '
    @alphabet.each { |letter| print letter + ' ' }
    puts
    puts 'Starile sunt: '
    @states.each { |state| print state.name + ' ' }
    puts
    puts "Starea initiala este: #{self.get_initial_state}"
    print 'Starile finale sunt: '
    self.get_final_states.each { |final_state| print final_state + ' ' }
    puts
    self.possible_moves_to_s
  end

  # checks if a given sequence is valid or not
  # sequence - String
  # maximum_length - Integer
  def is_valid_sequence(sequence, maximum_length: -1)
    if maximum_length != -1 && sequence.length > maximum_length
      return 'nu este acceptata intrucat este prea lunga'
    end
    first_try = "#{self.get_initial_state},#{sequence[0]}"
    sequence = sequence[1..-1]
    next_letter = @possible_moves[first_try]
    return "nu este acceptata intrucat (#{first_try}) nu exista" unless next_letter
    while sequence.length > 0
      next_try = "#{next_letter},#{sequence[0]}"
      sequence = sequence[1..-1]
      next_letter = @possible_moves[next_try]
      return "nu este acceptata intrucat (#{next_try}) nu exista" unless next_letter
    end
    if self.get_final_states.include? next_letter
      return 'este valida'
    end
    'nu este acceptata intrucat secventa a devenit vida, dar nu este intr-o stare finala'
  end

  # checks if a move exists from a certain state with a certain letter
  # state - String
  # letter - String
  def get_next_state(state, letter)
    try = "#{state},#{letter}"
    next_state = @possible_moves[try]
    return next_state if next_state
    'nu exista'
  end

  #returns a Grammar object
  def convert_into_grammar
    non_terminals = @states.map { |state| state.name }
    terminals = @alphabet
    initial = self.get_initial_state
    productions = {}
    non_terminals.each do |non_terminal|
      productions[non_terminal] = Array[]
    end
    @possible_moves.each do |key, value|
      parts = key.split(',')
      state = parts[0]
      letter = parts[1]
      productions[state].append("#{letter} #{value}")
      productions[state].append("#{letter}") if self.is_final_state(value)
    end

    Grammar.new(non_terminals, terminals, productions, initial)
  end

end