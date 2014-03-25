# dane dostępowe do bazy- zmienna- wartość (String)
# hash o podanej strukturze {:tabela => [nazwy kolumn]}, określający jakie kolumny znonimizujemy w jakich tabelach
# połączenie z bazą

# iteracja po hashu z nazwami tabel:
  hash.each do |tabela, kolumny|
    # tworzę klasę activerecord o nazwie dane tabeli => tworzy nowy obiekt jesli ten o podanej nazwie nie istnieje, ale że zakłądam że tabela istnieje wcześniej w bazie to zakłądam że to jest  istaniejąca tabela  
    moja_tabela = Object.const_set(tabela, Class.new(ActiveRecord::Base))
    # tu mamy dostep do nazw kolumn danej tabeli wiec iteruje po liscie z nazwami kolumn
    hash[tabela].each do |nazwakolumny|
      
        
      end
    end
  end



class Record < ActiveRecord::Base
end

Record.establish_connectiom(params)

tables.each do |name, columns|
  Record.set_table(name)

  Record.all.each do |record|
    columns.each do |column|
      value = record.send(column)
      new_value = change_value(value)
      record.send("#{column}=", value)
      record.save
    end
  end
end
