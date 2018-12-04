class Transacao
  attr_accessor :tipo, :moeda, :cotacao, :total

  def initialize(tipo, moeda, cotacao, total)
    @tipo = tipo
    @moeda = moeda
    @cotacao = format("%.2f", cotacao)
    @total = format("%.2f", total)
  end
  
  def to_s()
    puts
    puts "Tipo de operação: #{@tipo}"
    puts "Moeda: #{@moeda}"
    puts "Cotação: 1 dólar = #{@cotacao} reais"
    puts "Total da transação: #{@total} dólares"
  end
  
  def attributes
    instance_variables.map{|ivar| instance_variable_get ivar}
  end

  def self.to_real(valor, cotacao)
    valor * cotacao
  end
  
  def self.to_dolar(valor, cotacao)
    valor / cotacao
  end
  
  #Imprime transação no formato para ser salvo em arquivo, separado por ;
  def imprime()
    "#{@tipo};#{@moeda};#{@cotacao};#{@total}\n"
  end
end
