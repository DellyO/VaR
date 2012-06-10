require 'sinatra'
require 'gchart'
require "erb"

get '/' do
 @data = []
 chart_url = ""
 last_num = 0
 last_chart = ""

 unless params[:number].nil?
   last_chart = chart_url
   @data << params[:number].to_f
   @iterations_count = 0
   new_iter = params[:number]
   @iterations = []

   while new_iter.to_f != 1 do #go until we reach 1
     if new_iter.to_f > 2000000  #problem states no entries over 2mil
		print "The number was too big"
		new_iter = 1
	 elsif new_iter.to_f < 1 #problem requires positive entries
		print "The number wasn't positive, or it was zero"
		new_iter = 1
     elsif new_iter.to_f != new_iter.to_i  #problem states integers only
		print "The number wasn't an integer"
		new_iter = 1     
     elsif (new_iter.to_i % 2) == 0  #new iteration is even, n/2
       new_iter = new_iter.to_i/2
       @data << new_iter.to_i
	   @iterations << @iterations_count
       @iterations_count = @iterations_count+1		
     elsif (new_iter.to_i % 2) == 1  #new iteration is odd, 3n+1
       new_iter = (3*new_iter.to_i)+1
       @data << new_iter.to_i
	   @iterations << @iterations_count
       @iterations_count = @iterations_count+1	   
     end
   end
   chart_url = Gchart.line(:data => @data)
 end

#stores all the output into a variable
 x= %Q~
  <html>
    <body>
	  <% if params[:number].nil? %>
		<p>Welcome to Nathan's 3n+1 algorithm, enter a positive integer less than 2,000,000!</p>
		<form action="/" method="get">
        Number: <input type="text" name="number" />
        <input type="submit" /> <br>
		</form>
	  <% elsif params[:number].to_f != params[:number].to_i %>
		<p> I told you it had to be an integer!  Try again:</p>
		<form action="/" method="get">
        Number: <input type="text" name="number" />
        <input type="submit" /> <br>
		</form>
	  <% elsif params[:number].to_f > 2000000 %>
		<p> I told you it had to be less than 2,000,000!  Try again:</p>
		<form action="/" method="get">
        Number: <input type="text" name="number" />
        <input type="submit" /> <br>
		</form>	  
	  <% elsif params[:number].to_f < 1 %>
		<p> I told you it had to be a <b>positive number</b>!  Try again:</p>
		<form action="/" method="get">
        Number: <input type="text" name="number" />
        <input type="submit" /> <br>
		</form>
	  <% else %>
      <img src='#{chart_url}' />
      <form action="/" method="get">
        Number: <input type="text" name="number" />
        <input type="submit" /> <br>
		<p>Your number was <%= params[:number] %></p>
		<table>
			<td>
				<p>This took <%= @iterations_count %> iterations:</p>
				<ul><font size = "2">
					<% @iterations.each do |i| %>
						<li><%= @iterations[i] %>: <%= @data[i] %></li>
					<% end %>
					</font>
				</ul>
			</td>			
			<td>
				<% if last_num = 0 %>
				<p>When you put a new number in, I'll put your old one over here for you</p>
				<% else %>
				<p>Your previous number was x, and it took y iterations</p>
				<p>Here's what the chart looked like</p>
				<img src='#{last_chart}'>
				<% end %>
			</td>
		</table>
      </form>
	  <% end %>
    </body>
  </html>~
  
  #uses erb to output that whole variable
  erb x
end