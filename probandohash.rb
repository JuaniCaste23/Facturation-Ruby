hash=Hash.new

hash["God of War"]=["Santa Monica","PS4","500.00"]
hash["TLOU II"]=["Naugthy Dog","PS4","1000.00"]

hash.each do |producto,valor|
   puts"Producto: #{producto}\nDistribuidora: #{valor[0]}\nPlataforma: #{valor[1]}\nPrecio: #{valor[2]}\n\n"
end

puts (10.5).to_s