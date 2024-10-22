require 'colorize'
require 'D:\Facultate\An3\Sem1\LFTC\Lab3\tad.rb'

class Grammar
  # non_terminals - Array[String]
  # terminals - Array[String]
  # productions - Hash {S: [0, A, + A, - A]}
  # initial - String
  attr_accessor :non_terminals, :terminals, :productions, :initial

  # constructor
  def initialize(non_terminals, terminals, productions, initial)
    @non_terminals = non_terminals
    @terminals = terminals
    @productions = productions
    @initial = initial
  end

  # non_terminal - String
  # prints the productions of a given non-terminal
  def productions_with_non_terminal(non_terminal)
    puts "#{non_terminal} -> #{@productions[non_terminal].to_s.tr('[]"', '').gsub(', ', ' | ')}"
  end

  # prints a Grammar object
  def to_s
    puts 'Terminale:'.light_blue
    @terminals.each { |terminal_element| print terminal_element + ' '}
    puts "\nNon-terminale:".light_blue
    @non_terminals.each { |non_terminal_element| print non_terminal_element + ' '}
    puts "\nProductii:".light_blue
    @productions.each { |non_terminal, productions| puts "#{non_terminal} -> #{productions.to_s.tr('[]"', '').gsub(', ', ' | ')}"}
    puts 'Simbol de start: '.light_blue + "#{@initial}"
  end

  # returns Boolean value
  def is_regular
    if @productions[@initial].include?('epsilon')
      @productions.each do |non_terminal, productions|
        productions.each do |production|
          return false if production.include?(@initial)
        end
      end
    end
    @productions.each do |non_terminal, productions|
      productions.each do |production|
        if production.include?(' ')
          parts = production.split(' ')
          return false if parts.length > 2
          return false unless @terminals.include?(parts[0]) && @non_terminals.include?(parts[1])
        else
          return false unless @terminals.include?(production)
        end
      end
    end
    true
  end

  # returns TAD object
  def convert_into_finite_state_machine
    if self.is_regular
      states = Array[]
      @non_terminals.each do |non_terminal|
        state = State.new(initial: is_initial(non_terminal), final: is_final(non_terminal), name: non_terminal)
        states.append(state)
      end
      states.append(State.new(initial: false, final: true, name: 'K'))

      possible_moves = {}
      @non_terminals.each do |non_terminal|
        productions = @productions[non_terminal]
        productions.each do |production|
          if production.include?(' ')
            parts = production.split(' ')
            pair = "#{non_terminal},#{parts[0]}"
            next_state = parts[1]
            possible_moves[pair] = next_state
          elsif production != 'epsilon'
            pair = "#{non_terminal},#{production}"
            next_state = 'K'
            possible_moves[pair] = next_state
          end
        end
      end
      TAD.new(states, @terminals, possible_moves)
    end
  end

  private

  def is_initial(state)
    return true if state == @initial
    false
  end

  def is_final(state)
    productions = @productions[state]
    productions.each do |production|
      return true if production.include?('epsilon')
    end
    false
  end
end