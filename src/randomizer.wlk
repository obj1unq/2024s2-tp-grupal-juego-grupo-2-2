import armas.*
import extras.*
import wollok.game.*


object randomizer {

	const fabricas = [fabricaDeEspada, fabricaDeArcoYFlecha, fabricaDeMartilloDeGuerra]

	method agregarArmaRandom(_position) {
		const fabricaRnd = fabricas.anyOne()
		fabricaRnd.agregarNuevaArma(_position)
	}
	
}

