# dane dostępowe do bazy- zmienna- wartość (String)
# hash o podanej strukturze {:tabela => [nazwy kolumn]}, określający jakie kolumny znonimizujemy w jakich tabelach
# połączenie z bazą

# iteracja po hashu z nazwami tabel:
  hash.each do |tabela, kolumny|
    # tworzę klasę activerecord o nazwie dane tabeli => tworzy nowy obiekt jesli ten o podanej nazwie nie istnieje, ale że zakłądam że tabela istnieje wcześniej w bazie to zakłądam że to jest  istaniejąca tabela  
    moja_tabela = Object.const_set(tabela, Class.new(ActiveRecord::Base))
    # tu mamy dostep do nazw kolumn danej tabeli wiec iteruje po liscie z nazwami kolumn
    hash[tabela].each do |nazwakolumny|
      # teraz muszę iterować po nazwach kolumny i wyciagnac wszystkie wartosci z danej kolumny. 
      moja_tabela.select(nazwakolumny).each do |kolumna|
        #tu zmieniam te wartosci
        kolumna.nazwakolumny = '-'*nazwakolumny.length
        
      end
    end
  end
