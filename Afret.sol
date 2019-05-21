pragma solidity 0.5.8;

contract TimeCharter {
    address payable armador;
    uint valorTotalArrendamento;
    uint parcelaA2rrendamento;
    uint parcela1Afretamento;
    uint parcela2Afretamento;
    uint capacidadeDeCarga;
    uint distancia;
    event arrendamentoPago1parc (address payable armador);
    event embarcacaoLiberada (address payable proprietario);
    event carregamentoRealizado (bytes32 IdAfretador);
    event cargaLiberada (bytes32 IdAfretador);
    event arrendamentoQuitado (bytes32 IdAfretador);
    
    struct Carga {
        uint peso;
        uint volume;
        address payable afretador;
        bool capacidadeExcedida;
       
    Carga[] cargas;
       
    }
   
    modifier somenteProprietario(address payable proprietario) {
        require(msg.sender == proprietario);
        _;
       
    }
       
    modifier somenteArmador() {
            require(msg.sender == armador);
        _;
    }
   
    enum Status {embarcacaoDisponivel, prontoParaCarga, emTransitoAoDestino, noPortoDeDestino}
    Status public statusAtual;
 
    constructor(uint cargaPretendida, address payable IdAfretador) public payable {
        armador = msg.sender;
        cargaPretendida = msg.value;
        IdAfretador = IdAfretador;
    }
   
    modifier noStatus(Status statusDesejado) {
        require(statusAtual == statusDesejado);
        _;
   
    }
    function liberarEmbarcacao(address payable proprietario, uint parcela1Arrendamento) public payable somenteArmador {
        require(msg.sender == armador);
        require(msg.value == parcela1Arrendamento);
        parcela1Arrendamento = address(this).balance;
        proprietario.transfer((address(this).balance));
       
    }
   
    function confirmarLiberacao(address payable proprietario) public view {
        require(msg.sender == proprietario, "Embarca��o Liberada");
    }
   
    function carregamento(uint CargaPretendida, uint disponibilidadeDeCarga)
    noStatus(Status.prontoParaCarga) public payable {
        require(CargaPretendida <= disponibilidadeDeCarga);
        require(msg.value == parcela1Afretamento);
        parcela1Afretamento = address(this).balance;
        armador.transfer((address(this).balance));
    }
   
    function calculaParcelaVariavel(uint parcelaVariavel, uint despesasPortuarias, uint despachante, uint demurrage, uint taxas) pure public returns(uint) {
        parcelaVariavel = despesasPortuarias + demurrage + despachante + taxas;
        return parcelaVariavel;
       
    }
   
    function calculaAbatimentoAtraso(uint prazoEstimado, uint prazoChegada) pure public returns(uint) {
        uint abatimentoAtraso = prazoEstimado + prazoChegada;
        uint indiceMulta = 15;
        uint parcelaVariavel;
        if (prazoEstimado < prazoChegada) {
            abatimentoAtraso = (parcelaVariavel*indiceMulta)/100;
            return abatimentoAtraso;
        }
    }
   
    function liberarCarga(uint parcelaVariavel, uint abatimentoAtraso) public payable
    noStatus(Status.noPortoDeDestino) {
        uint parcelaFinal = parcelaVariavel - abatimentoAtraso;
        parcelaFinal = address(this).balance;
        require(msg.value == parcelaFinal, "Carga Liberada");
        armador.transfer(address(this).balance);
    }
    function reentregaEmbarcacao(address payable proprietario) public payable somenteArmador {
        uint parcela2Arrendamento = address(this).balance;
        require(msg.value == parcela2Arrendamento, "Embarca��o Liberada para Reentrega");
        proprietario.transfer(address(this).balance);
    }
}
