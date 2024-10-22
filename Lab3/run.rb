require_relative 'tad'

# returns an Array with all accepted letters
def read_alphabet(letters)
  letters = letters.strip
  array_of_received_alphabet = letters.split(' ')
  array_of_accepted_alphabet = Array[]
  array_of_received_alphabet.each { |letter|
    letter.strip
    if letter == 'cifra'
      (0..9).each { |i|
        array_of_accepted_alphabet.push(i.to_s)
      }
    elsif letter == 'litera'
      ('a'..'z').each { |i|
        array_of_accepted_alphabet.push(i.to_s)
      }
      ('A'..'Z').each { |i|
        array_of_accepted_alphabet.push(i.to_s)
      }
    else
      array_of_accepted_alphabet.push(letter)
    end
  }
  array_of_accepted_alphabet
end

# returns a TAD object
def read_config_file(file_path)
  lines = []
  File.open(file_path, 'r') do |file|
    lines = file.readlines
  end

  alphabet = read_alphabet(lines[0])

  states = Array[]
  initial_state = lines[1].strip
  stripped = lines[2].strip
  array_of_final_states = stripped.split(' ')
  stripped = lines[3].strip
  array_of_states = stripped.split(' ')
  array_of_states.each do |state|
    state_obj = State.new
    state_obj.name = state
    if array_of_final_states.include? state
      state_obj.final = true
    else
      state_obj.final = false
    end
    if state == initial_state
      state_obj.initial = true
    else
      state_obj.initial = false
    end
    states.push(state_obj)
  end

  nr_of_lines = lines.length
  possible_moves = {}
  (4..nr_of_lines-1).each do |line_nr|
    stripped = lines[line_nr].strip
    parts = stripped.split(' -> ')
    state = parts[0].split(',')[0]
    letter = parts[0].split(',')[1]
    if letter == 'cifra'
      (0..9).each do |digit|
        first_part = "#{state},#{digit}"
        possible_moves[first_part] = parts[1]
      end
    elsif letter == 'cifraNenula'
      (1..9).each do |digit|
        first_part = "#{state},#{digit}"
        possible_moves[first_part] = parts[1]
      end
    elsif letter == 'litera'
      ('a'..'z').each do |digit|
        first_part = "#{state},#{digit}"
        possible_moves[first_part] = parts[1]
      end
      ('A'..'Z').each do |digit|
        first_part = "#{state},#{digit}"
        possible_moves[first_part] = parts[1]
      end
    elsif letter == 'literaMica'
      ('a'..'z').each do |digit|
        first_part = "#{state},#{digit}"
        possible_moves[first_part] = parts[1]
      end
    else
      possible_moves[parts[0]] = parts[1]
    end
  end

  tad = TAD.new(states, alphabet, possible_moves)
end

def run_numbers
  numbers = read_config_file('D:\Facultate\An3\Sem1\LFTC\Lab3\constants')
  numbers.to_s
  sequence = '23a'
  puts "secventa #{sequence} #{numbers.is_valid_sequence(sequence)}"
  puts numbers.get_next_state('s', '7')
  numbers.convert_into_grammar
end

def run_identifiers
  identifiers = read_config_file('D:/Facultate/An3/Sem1/LFTC/identifiers')
  identifiers.to_s
  sequence = 'aNa123'
  puts "secventa #{sequence} #{identifiers.is_valid_sequence(sequence, maximum_length: 8)}"
  puts identifiers.get_next_state('p', 'a')
end

def run
  finite_state_machine = read_config_file('D:\Facultate\An3\Sem1\LFTC\Lab3\constants')
  finite_state_machine.convert_into_grammar.to_s
end

run