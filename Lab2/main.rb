require_relative 'bst'
require 'colorize'

$tokens = Array[]
$success = true

def keywords
	Array['READ', 'WRITE', 'IF', 'WHILE', 'THEN', 'ELSE', 'VAR', 'BEGIN', 'END', 'ARRAY', 'OF', 'CHAR', 'CONST', 'INTEGER', 'TRUE', 'FALSE']
end

def special_symbols
	Array[';', ':', '[', ']', '{', '}', '(', ')']
end

def simple_operators
	Array['=', '+', '-', '*', '/', '<', '>', '%']
end

def compound_operators
	Array['==', '<=', '>=']
end

def is_keyword(token)
	token = token.strip
	return true if keywords.include? token
	false
end

def is_special_symbol(token)
	token = token.strip
	return true if special_symbols.include? token
	false
end

def is_simple_operator(token)
	token = token.strip
	return true if simple_operators.include? token
	false
end

def is_compound_operator(token)
	token = token.strip
	return true if compound_operators.include? token
	false
end

def is_identifier(token)
	token = token.strip
	return true if token.match(/^[a-z][a-zA-Z0-9]{0,7}$/)
	false
end

def is_number(token)
	token = token.strip
	return true if token.match(/^[+-]?[1-9][0-9]*$/)
	return true if token.match(/^0$/)
	false
end

def is_character(token)
	token = token.strip
	return true if token.match(/^'[a-zA-Z]'$/)
	false
end

# line - a line from the source code
# line_nr - the line number
def add_tokens_to_array(line, line_nr)
	if line == ''
		return
	end

	if is_keyword(line) || is_special_symbol(line) || is_simple_operator(line) || is_compound_operator(line) || is_identifier(line) || is_number(line) || is_character(line)
		$tokens.push({token: line, token_line: line_nr})
		return
	end

	if line.include? ' '
		new_tokens = line.split(' ')
		for t in new_tokens
			add_tokens_to_array(t, line_nr)
		end
		return
	end

	for symbol in special_symbols
		if line.include? symbol
			split_by = symbol
			token_split = line.split(split_by, 2)
			if line.start_with? split_by
				$tokens.push({token: split_by, token_line: line_nr})
				add_tokens_to_array(token_split[1], line_nr)
				return
			elsif line.end_with? split_by
				add_tokens_to_array(token_split[0], line_nr)
				$tokens.push({token: split_by, token_line: line_nr})
				return
			else
				add_tokens_to_array(token_split[0], line_nr)
				$tokens.push({token: split_by, token_line: line_nr})
				add_tokens_to_array(token_split[1], line_nr)
				return
			end
		end
	end

	for compound_op in compound_operators
		if line.include? compound_op
			split_by = compound_op
			token_split = line.split(split_by, 2)
			if line.start_with? split_by
				$tokens.push({token: split_by, token_line: line_nr})
				add_tokens_to_array(token_split[1], line_nr)
				return
			elsif line.end_with? split_by
				add_tokens_to_array(token_split[0], line_nr)
				$tokens.push({token: split_by, token_line: line_nr})
				return
			else
				add_tokens_to_array(token_split[0], line_nr)
				$tokens.push({token: split_by, token_line: line_nr})
				add_tokens_to_array(token_split[1], line_nr)
				return
			end
		end
	end

	for simple_op in simple_operators
		if line.include? simple_op
			split_by = simple_op
			token_split = line.split(split_by, 2)
			if line.start_with? split_by
				$tokens.push({token: split_by, token_line: line_nr})
				add_tokens_to_array(token_split[1], line_nr)
				return
			elsif line.end_with? split_by
				add_tokens_to_array(token_split[0], line_nr)
				$tokens.push({token: split_by, token_line: line_nr})
				return
			else
				add_tokens_to_array(token_split[0], line_nr)
				$tokens.push({token: split_by, token_line: line_nr})
				add_tokens_to_array(token_split[1], line_nr)
				return
			end
		end
	end

	$success = false
	puts "Eroare aparuta pentru #{line} la linia #{line_nr}".red
end

# returns an array with all the tokens in this format {token, line_of_token}
def read_source_code(file_path)
	line_nr = 1
	lines = []
	File.open(file_path, 'r') do |file|
		lines = file.readlines
	end
	lines.each { |line|
		add_tokens_to_array(line.strip, line_nr)
		line_nr += 1
	}
end

# returns a hash with the token codes
def read_token_codes(file_path)
	lines = []
	File.open(file_path, 'r') do |file|
		lines = file.readlines
	end

	codes = {}
	lines.each { |line|
		token_and_code = line.split(' ')
		tok = token_and_code[0]
		c = token_and_code[1]
		codes[tok] = c
	}
	codes
end

def main
	read_source_code('D:/Facultate/An3/Sem1/LFTC/Lab2/fisier_cod')
	codes = read_token_codes('D:/Facultate/An3/Sem1/LFTC/Lab2/coduri_atomi')
	if $success
		fip = Array[]
		identifiers = BST.new
		constants = BST.new
		identifier_id = 1
		constant_id = 1
		all_identifiers = Array[]
		all_constants = Array[]
		identifiers_ids = {}
		constant_ids = {}
		$tokens.each { |token|
			el = token[:token]

			if is_identifier(el) && !(identifiers.contains?(el))
				identifiers.insert(el)
				all_identifiers.push({id: identifier_id, token: el})
				identifiers_ids[el] = identifier_id
				identifier_id += 1
			end

			if (is_number(el) || is_character(el)) && !(constants.contains?(el))
				constants.insert(el)
				all_constants.push({id: constant_id, token: el})
				constant_ids[el] = constant_id
				constant_id += 1
			end
		}
		all_identifiers.each do |i|
			value = i[:token]
			parent_and_sibling = identifiers.find_parent_and_sibling(value)

			if parent_and_sibling[0] != -1
				i[:parent] = identifiers_ids[parent_and_sibling[0]]
			else
				i[:parent] = -1
			end
			if parent_and_sibling[1] != -1
				i[:sibling] = identifiers_ids[parent_and_sibling[1]]
			else
				i[:sibling] = -1
			end
		end

		all_constants.each do |c|
			value = c[:token]
			parent_and_sibling = constants.find_parent_and_sibling(value)

			if parent_and_sibling[0] != -1
				c[:parent] = constant_ids[parent_and_sibling[0]]
			else
				c[:parent] = -1
			end
			if parent_and_sibling[1] != -1
				c[:sibling] = constant_ids[parent_and_sibling[1]]
			else
				c[:sibling] = -1
			end
		end

		$tokens.each { |token|
			el = token[:token]

			if is_keyword(el) || is_special_symbol(el) || is_simple_operator(el) || is_compound_operator(el)
				fip.push({token_code: codes[el], TS: -1})
			end

			if is_identifier(el)
				fip.push({token_code: 0, TS: identifiers_ids[el]})
			end

			if is_number(el) || is_character(el)
				fip.push({token_code: 1, TS: constant_ids[el]})
			end
		}

		puts 'Tabela simboluri pentru identificatori'.light_blue
		puts all_identifiers
		puts 'Tabela simboluri pentru constante'.light_blue
		puts all_constants
		puts 'Forma interna a programului'.light_blue
		puts fip
		puts 'Lista tokeni si pozitia lor in codul sursa'.light_blue
		puts $tokens
	end
end

main
