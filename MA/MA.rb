#Program for finding moving average crossover points

require 'csv'

price_data = []
ma_data = []
crossovers_from_above = []
crossovers_from_below = []
csv_file = "C:/RubyStuff/MA/Pepsi.csv"

from_above_day0 = []
from_above_day0_return = []
from_above_day1 = []
from_above_day1_return = []
from_below_day0 = []
from_below_day0_return = []
from_below_day1 = []
from_below_day1_return = []

CSV.foreach(csv_file) {|row| price_data << row[0]}
CSV.foreach(csv_file) {|row| ma_data << row[1]}

#Do first iteration to set state
if price_data[0] > ma_data[0]
	state = "OVER"
else
	state = "UNDER"
end

(1..price_data.size-1).each do |i|
	if price_data[i] > ma_data[i]
		#price was higher than MA, still higher than MA => nothing
		if state == "OVER"
			next
		#price was lower than MA, now is higher => crossover
		elsif state == "UNDER"
			crossovers_from_below << i
			state = "OVER"
		end				
	elsif price_data[i] < ma_data[i]
		#price was higher than MA, now is lower => crossover
		if state == "OVER"
			crossovers_from_above << i
			state = "UNDER"
		elsif state == "UNDER"
			next
		end
	end
end

(0..crossovers_from_above.size-2).each do |j|
	from_above_day0_return << price_data[crossovers_from_above[j]].to_f / price_data[crossovers_from_above[j]-1].to_f 
	from_above_day0 << price_data[crossovers_from_above[j]]
	from_above_day1_return << price_data[crossovers_from_above[j+1]].to_f  / price_data[crossovers_from_above[j+1]-1].to_f 
	from_above_day1 << price_data[crossovers_from_above[j]+1]
end
(0..crossovers_from_below.size-2).each do |k|
	from_below_day0_return << price_data[crossovers_from_below[k]].to_f  / price_data[crossovers_from_below[k]-1].to_f 
	from_below_day0 << price_data[crossovers_from_below[k]]
	from_below_day1_return << price_data[crossovers_from_below[k+1]].to_f  / price_data[crossovers_from_below[k+1]-1].to_f 
	from_below_day1 << price_data[crossovers_from_below[k]+1]
end

CAresultsFile = File.open("CAoutput.txt", "w+")
CBresultsFile = File.open("CBoutput.txt", "w+")
CAresultsFile << "Crossovers From Above \n"
CBresultsFile << "Crossovers From Below \n"
CAresultsFile << "Day 0, Day 0 Return, Day 1, Day 1 Return \n"
CBresultsFile << "Day 0, Day 0 Return, Day 1, Day 1 Return \n"
(0..from_above_day0.size-1).each do |l|
	CAresultsFile << "#{from_above_day0[l]}, #{from_above_day0_return[l]}, #{from_above_day1[l]}, #{from_above_day1_return[l]} \n"
end
(0..from_below_day0.size-1).each do |m|
	CBresultsFile << "#{from_below_day0[m]}, #{from_below_day0_return[m]}, #{from_below_day1[m]}, #{from_below_day1_return[m]} \n"
end