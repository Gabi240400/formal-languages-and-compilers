require_relative 'grammar'

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

def actual_values_of(symbol)
  if symbol == 'cifra'
    result = ''
    (0..9).each do |digit|
      result += digit.to_s + ','
    end
    return result[0...-1]
  elsif symbol == 'cifraNenula'
    result = ''
    (1..9).each do |digit|
      result += digit.to_s + ','
    end
    return result[0...-1]
  elsif symbol == 'litera'
    result = ''
    ('a'..'z').each do |digit|
      result += digit + ','
    end
    ('A'..'Z').each do |digit|
      result += digit + ','
    end
    return result[0...-1]
  elsif symbol == 'literaMica'
    result = ''
    ('a'..'z').each do |digit|
      result += digit + ','
    end
    return result[0...-1]
  else
    symbol
  end
end

def read_config_file(file_path)
  lines = []
  File.open(file_path, 'r') do |file|
    lines = file.readlines
  end

  non_terminals = lines[0].split(' ')
  initial = non_terminals[0]
  alphabet = read_alphabet(lines[1])
  productions = {}
  non_terminals.each do |non_terminal|
    productions[non_terminal] = Array[]
  end

  nr_of_lines = lines.length
  (2..nr_of_lines - 1).each do |line_nr|
    stripped = lines[line_nr].strip
    parts = stripped.split(' -> ')
    left_part = parts[0]
    right_part = parts[1]
    elements = right_part.split(' ')
    elements.map!  { |element| actual_values_of(element) }
    string_to_be_solved = elements.join(' ')
    new_productions = resolver(Array[string_to_be_solved])
    productions[left_part] = productions[left_part].push(*new_productions)
  end

  Grammar.new(non_terminals, alphabet, productions, initial)
end

def get_index_where_alphabet_is(str)
  index = 0
  parts = str.split(' ')
  parts.each do |part|
    if part.include?(',')
      return index
    end
    index += 1
  end
end

def resolver(list)
  first_element = list[0]
  return list unless first_element.include?(',')
  index = get_index_where_alphabet_is(first_element)
  len = first_element.split(' ').length

  new_list = Array[]
  list.each do |unresolved_string|
    all_parts_of_unresolved_string = unresolved_string.split(' ')
    letters = all_parts_of_unresolved_string[index].split(',')
    letters.each do |letter|
      string_to_be_appended = ''
      string_to_be_appended += all_parts_of_unresolved_string.first(index).join(' ') + ' ' if index != 0
      string_to_be_appended += letter
      string_to_be_appended += ' ' + all_parts_of_unresolved_string.last(len - index - 1).join(' ') if index != len - 1
      new_list.append(string_to_be_appended)
    end
  end

  resolver(new_list)
end

def menu
  puts '1. Afisare gramatica'
  puts '2. Afisarea productiilor unui non-terminal'
  puts '3. Verificarea regularitatii gramaticii'
  puts '4. Conversia intr-un automat finit'
end

def run
  grammar = read_config_file('D:\Facultate\An3\Sem1\LFTC\Lab4\grammar')
  menu
  puts 'Optiunea aleasa: '
  opt = gets.chomp.to_i
  while opt > 0 && opt < 5
    if opt == 1
      grammar.to_s
    elsif opt == 2
      puts 'Scrie un non-terminal: '
      non_terminal = gets.chomp
      grammar.productions_with_non_terminal(non_terminal)
    elsif opt == 3
      puts grammar.is_regular
    elsif opt == 4
      grammar.convert_into_finite_state_machine.to_s
    end
    menu
    puts 'Optiunea aleasa: '
    opt = gets.chomp.to_i
  end
end


run
