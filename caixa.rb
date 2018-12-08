require_relative 'transacao'

class Caixa
  attr_accessor :id_caixa, :nome_caixa, :date, :cotacao, :dolares, :reais
  
  def initialize(id_caixa:, nome_caixa:, date:, cotacao:, dolares:, reais:)
    @id_caixa = id_caixa
    @nome_caixa = nome_caixa
    @date = date
    @cotacao = cotacao
    @dolares = dolares
    @reais = reais
  end
  
  def compra_dolares(valor)
    if valor > Transacao.to_dolar(@reais, @cotacao)
      puts "\nNão foi possível realizar a operação! Você não possui reais o suficiente!"
    elsif confirma_transacao?(valor, 'dólares')
      @dolares += valor
      @reais -= Transacao.to_real(valor, @cotacao)
      transacao = Transacao.new(tipo: 'Compra', moeda: 'Dolar', cotacao: @cotacao, total: valor, id_caixa: @id_caixa)
      realiza_transacao(transacao)
    else
      puts 'Operação cancelada pelo usuário!'
    end
  end
  
  def vende_dolares(valor)
    if valor > @dolares
      puts "\nNão foi possível realizar a operação! Você não possui dólares o suficiente!"
    elsif confirma_transacao?(valor, 'dólares')
      @dolares -= valor
      @reais += Transacao.to_real(valor, @cotacao)
      transacao = Transacao.new(tipo: 'Venda', moeda: 'Dolar', cotacao: @cotacao, total: valor, id_caixa: @id_caixa)
      realiza_transacao(transacao)
    else
      puts 'Operação cancelada pelo usuário!'
    end
  end
  
  def compra_reais(valor)
    if valor > Transacao.to_real(@dolares, @cotacao)
      puts "\nNão foi possível realizar a operação! Você não possui dólares o suficiente!"
    elsif confirma_transacao?(valor, 'reais')
      @reais += valor
      @dolares -= Transacao.to_dolar(valor, @cotacao)
      transacao = Transacao.new(tipo: 'Compra', moeda: 'Real', cotacao: @cotacao, 
                                total: Transacao.to_dolar(valor, @cotacao), id_caixa: @id_caixa)
      realiza_transacao(transacao)
    else
      puts 'Operação cancelada pelo usuário!'
    end
  end
  
  def vende_reais(valor)
    if valor > @reais
      puts "\nNão foi possível realizar a operação! Você não possui reais o suficiente!"
    elsif confirma_transacao?(valor, 'reais')
      @reais -= valor
      @dolares += Transacao.to_dolar(valor, @cotacao)
      transacao = Transacao.new(tipo: 'Venda', moeda: 'Real', cotacao: @cotacao, 
                                total: Transacao.to_dolar(valor, @cotacao), id_caixa: @id_caixa)
      realiza_transacao(transacao)
    else
      puts 'Operação cancelada pelo usuário!'
    end
  end
  
  def confirma_transacao?(valor, moeda)
    puts "\nValor total da transação:" 
    puts "#{format("%.2f", valor)} #{moeda}"
    (moeda == 'dólares') && (puts "#{format("%.2f", Transacao.to_real(valor, @cotacao))} reais") or
    (moeda == 'reais') && (puts "#{format("%.2f", Transacao.to_dolar(valor, @cotacao))} dólares")

    loop do
      puts "\nConfirma transação? (s/n)"
      resposta = gets.chomp
      (resposta == 's') && (return true) or
      (resposta == 'n') && (return false) or
      puts 'Resposta inválida!' 
    end
  end

  # Finaliza a operação, gravando no banco de dados e retornando informações sobre a transação
  def realiza_transacao(transacao)
    transacao.salva_transacao
    puts 'Operação realizada com sucesso!'
    puts transacao 
  end
  
  # Imprime no terminal informações atualizadas sobre o caixa
  def to_s
    rows = []
    rows << ['Cotação do dia', "1 dólar = #{format("%.2f", @cotacao)} reais"]
    rows << ['Dólares disponíveis', "$ #{format("%.2f", @dolares)}"]
    rows << ['Reais disponíveis', "R$ #{format("%.2f", @reais)}"]
    table = Terminal::Table.new :title => "Informações sobre o caixa", :rows => rows
    table.to_s
  end

  def salva_caixa
    db = SQLite3::Database.open 'cambio.db'
    db.execute("INSERT INTO cashiers (nome_caixa,date,cotacao,dolares,reais) VALUES (?,?,?,?,?) ",
        @nome_caixa,
        @date, 
        @cotacao, 
        @dolares, 
        @reais
    )
    db.close   
  end

  # Atualiza informações do caixa do dia no banco de dados
  def atualiza_caixa
    puts
    @date = DateTime.now.strftime("%Y-%m-%d")
    print 'Insira a cotação atual do dólar (em reais): '
    @cotacao = gets.to_f
    print 'Insira o montante de DÓLARES disponíveis: $ '
    @dolares = gets.to_f
    print 'Insira o montante de REAIS disponíveis: R$ '
    @reais = gets.to_f
    db = SQLite3::Database.open 'cambio.db'
    db.execute("UPDATE cashiers SET date = ?, cotacao = ?, dolares = ?, reais = ? WHERE date = ? AND nome_caixa = ?", 
        @date, 
        @cotacao, 
        @dolares, 
        @reais,
        @date,
        @nome_caixa
    )
    db.close
    puts "Caixa atualizado com sucesso!"
  end

end