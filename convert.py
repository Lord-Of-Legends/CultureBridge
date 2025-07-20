# Input string
input_data = """kill:5.0
suicide:5.0
commit:5.0
cut:2.0
cutting:2.0
selfharm:2.5
burn:1.5
burning:1.5
harm:1.0
bleed:2.0
bleeding:2.0
pain:1.0
suicidal:2.5
killmyself:2.5
die:1.0
dying:1.5
worthless:1.5
hopeless:1.5
endit:2.0
jump:1.5
overdose:2.5
hurt:1.0
death:2.5

"""

# Split and convert into SQL insert format
entries = input_data.split()
sql_lines = [f"('{word_weight.split(':')[0]}', {word_weight.split(':')[1]})" for word_weight in entries]

# Join with commas and wrap in full INSERT statement
sql_output = "insert into self-harm_words (word, weight) values\n" + ",\n".join(sql_lines) + ";"

# Print the result
print(sql_output)
