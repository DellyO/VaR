# Nathan Dell
# Monte Carlo method for computing VaR
# Specifically for pep, cat, msft, bac, C Weekly Returns
# Dating from Jan 1, 1998 to Jan 1, 2013

require 'csv'

returns_data = []
# Read in returns csv file
csv_file = "C:/RubyStuff/VaR/Returns.csv"

# Initialize returns arrays
pep_returns = []
cat_returns = []
msft_returns = []
bac_returns = []
c_returns = []

# Fill returns arrays
CSV.foreach(csv_file) {|row| pep_returns << row[0]}
CSV.foreach(csv_file) {|row| cat_returns << row[1]}
CSV.foreach(csv_file) {|row| msft_returns << row[2]}
CSV.foreach(csv_file) {|row| bac_returns << row[3]}
CSV.foreach(csv_file) {|row| c_returns << row[4]}

# Initialize and set length variables
pep_len = pep_returns.length
cat_len = cat_returns.length
msft_len = msft_returns.length
bac_len = bac_returns.length
c_len = c_returns.length

# Create arrays to hold pseudo-returns
pep_pseudos = []
cat_pseudos = []
msft_pseudos = []
bac_pseudos = []
c_pseudos = []

# Set number of iterations
# In weekly data, iters=52 would be one year
# iters sets the number of Monte Carlo simulations
iters = 52
sims = 1000

# Set starting weights
pep_w = 0.20
cat_w = 0.20
msft_w = 0.20
bac_w = 0.20
c_w = 0.20

# Set starting values
i_pep_value = 1000
i_cat_value = 1000
i_msft_value = 1000
i_bac_value = 1000
i_c_value = 1000

# Initialize array of portfolio values
Port_values = []

init_Port = pep_w * i_pep_value + cat_w * i_cat_value + msft_w * i_msft_value + bac_w * i_bac_value + c_w * i_c_value

for k in 0..sims
	# Set starting price values
	# These need to reset each simulation
	pep_value = i_pep_value
	cat_value = i_cat_value
	msft_value = i_msft_value
	bac_value = i_bac_value
	c_value = i_c_value
	
	# Populate initial pseudo-return values since algorithm will use [i-1]
	pep_pseudos[0] = pep_returns[rand(pep_len+1)].to_f
	cat_pseudos[0] = cat_returns[rand(cat_len+1)].to_f
	msft_pseudos[0] = msft_returns[rand(msft_len+1)].to_f
	bac_pseudos[0] = bac_returns[rand(bac_len+1)].to_f
	c_pseudos[0] = c_returns[rand(c_len+1)].to_f
	
	# Calculate pseudo arrays
	for i in 1..iters
		pep_pseudos[i] = pep_pseudos[i-1] * (1 + pep_returns[rand(pep_len+1)].to_f)
		cat_pseudos[i] = cat_pseudos[i-1] * (1 + cat_returns[rand(cat_len+1)].to_f)
		msft_pseudos[i] = msft_pseudos[i-1] * (1 + msft_returns[rand(msft_len+1)].to_f)
		bac_pseudos[i] = bac_pseudos[i-1] * (1+ bac_returns[rand(bac_len+1)].to_f)
		c_pseudos[i] = c_pseudos[i-1] * (1 + c_returns[rand(c_len+1)].to_f)
	end
	
	# Run values through an iteration
	for j in 0..(pep_pseudos.length-1)
		pep_value *= (1 + pep_pseudos[j])
		cat_value *= (1 + cat_pseudos[j])
		msft_value *= (1 + msft_pseudos[j])
		bac_value *= (1 + bac_pseudos[j])
		c_value *= (1 + c_pseudos[j])
	end
	
	# Calculate new portfolio value
	Port_values[k] = pep_w * pep_value + cat_w * cat_value + msft_w * msft_value + bac_w * bac_value + c_w * c_value
end
		
port_PL = []
# Output portfolio P/L
for n in 0..(Port_values.length-1)
	port_PL[n] = Port_values[n] - init_Port
end

puts port_PL
	

