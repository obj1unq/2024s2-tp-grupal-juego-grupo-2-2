import armas.*
import extras.*
import wollok.game.*


object randomizer {

	const fabricas = [fabricaEspada, fabricaArcoYFlecha, fabricaMartilloDeGuerra]

	method armaRandom() {
		const fabricaRnd = fabricas.anyOne()
		return fabricaRnd.nuevaArma()
	}

	method posicionRandomDeArma() {
		const posRnd = [[6,3], [6,7], [4,7], [2,7], [3,10], [11,9], [11,6]].anyOne()
		return game.at(posRnd.head(), posRnd.last())
	}

	method posicionRandomDeCorazon() {
		const posRnd = [[2,19], [27,19], [27,2]].anyOne() //solo esquinas del tablero que no sean en la que empieza el personaje
		return game.at(posRnd.head(), posRnd.last())
	}

	method position() {
		return 	game.at( 
					(0 .. game.width() - 1 ).anyOne(),
					(0..  game.height() - 1).anyOne()
		) 
	}
	
	method emptyPosition() {
		const position = self.position()
		if(game.getObjectsIn(position).isEmpty()) {
			return position	
		}
		else {
			return self.emptyPosition()
		}
	}
	
	method randomDe1Hasta(numero) {
		return 1.randomUpTo(numero).round()
	}
	
}

