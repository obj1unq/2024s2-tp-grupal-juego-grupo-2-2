import wollok.game.*
import personaje.*
import randomizer.*
import paleta.*
import enemigos.*
import mapa.*
import niveles.*

object dungeon {

    var property ambiente = game.sound("ambiente.mp3") //var porque ¿la vamos a ir cambiando con los niveles?

    method comenzarMusicaAmbiente() {
        ambiente.play()
    }

    method detenerMusicaAmbiente() {
        ambiente.stop()
    }

    method comenzarLoopMusicaAmbiente() {
        ambiente.shouldLoop(true)
    }

    method detenerLoopMusicaAmbiente() { //por ahora no se usa. lo cree por el tema de la musica ambiente que no paraba al perder.
        ambiente.shouldLoop(false)
    }

    const property enemigos = []
    const property objetosNoTraspasables = []

    method registrarEnemigo(enemigo) {
        enemigos.add(enemigo)
    }

    method sacarEnemigo(enemigo) {
        enemigos.remove(enemigo)
    }

    method registrarObjetoNoTraspasable(objeto) {
        objetosNoTraspasables.add(objeto)
    }

    method removerEnemigos(){
        enemigos.forEach( {e => enemigos.remove(e) } )
    }

    method removerObjetosNoTraspasables() {
        objetosNoTraspasables.forEach( {o => objetosNoTraspasables.remove(o) } )
    }

    method accionEnemigos() {
        enemigos.forEach({enemigo => enemigo.reaccionarAMovimiento()})
    }

    method validarDentro(posicion) {
        if (!self.estaDentro(posicion)) {
            self.error("")
        }
    }

    method estaDentro(posicion) {
        return posicion.x().between(2, game.width() - 3) && posicion.y().between(2, game.height() - 6) 
    }

    method validarNoHayObjetoNoTraspasable(posicion) {
        if(self.hayObjetoNoTraspasable(posicion)) {
            self.error("")
        }
    }

    method hayObjetoNoTraspasable(posicion) {
        return objetosNoTraspasables.any({objeto => objeto.position() == posicion})
    }

    method hayEnemigoEn(celda){
        return enemigos.any({enemigo => enemigo.position() == celda})
    }

    method hayAlgoEn(celda) {
        return self.hayEnemigoEn(celda) || self.hayObjetoNoTraspasable(celda)
    }

    //animacion enemigos

    method animacionEnemigos(){
        enemigos.forEach({enemigo => enemigo.cambiarAnimacion()})
    }
    
    //Pasar nivel
    var nivelNum = 0
    const niveles = [nivel1, nivel2, arenaJefe]

    method nivelActual() {
        return niveles.get(nivelNum)
    } 

    method limpiarTablero() {
        self.nivelActual().limpiarTablero()
    }

    method abrirPuertaSiSePuede(){
        if(personaje.enemigosAsesinados() >= self.nivelActual().enemigosSpawneados()){
            puerta.abrirPuerta()
            console.println("estaAbierta")
        }
    
    }

    method cerraPuerta(){
        puerta.reiniciarPuerta()
        console.println("estaCerrada")
    }

    method siguienteNivel(){ 
        nivelNum = (nivelNum + 1 ) % 3
    }

    method pasarNivel(){
        self.removerEnemigos()  //sin esto la lista de enemigos de la dungeon tiene enemigos dentro que se cargar invisibles si Quedan despues de pasar de nivel
        self.removerObjetosNoTraspasables() //este sí va!! si no, los objetos quedan intraspasables para los siguientes lvls
        self.nivelActual().pasarNivel()
    }

    //Dibujar
    method dibujar(){
    //OBJETOS CON LOS QUE NO SE INTERACTUA
	//gestorDeFondo.image("fondoNivel1.png")
	game.addVisual(indicadorDeObjetos)
	game.addVisual(primeraArma)
	game.addVisual(segundaArma)
	game.addVisual(terceraArma)
	game.addVisual(salud)
	game.addVisual(vidas)
	game.addVisual(pociones)
	game.addVisual(barraFuerza)


    game.addVisual(enemigosAsesinadosNivelActual)

	
	//PERSONAJE
	game.addVisual(personaje)
    game.addVisual(puerta)
    }

}

object juego {
    var comenzado = false

    method empezar() {
        self.validarYaComenzo()
        comenzado = true
        gestorDeFondo.image("fondoPrincipio2.png")
        game.schedule(7000, {gestorDeFondo.image("fondoPrincipio3.png")})
        game.schedule(10000, {self.cargar()})
    }

    method validarYaComenzo() {
        if(comenzado) {
            self.error("")
        }
    }

    method cargar() {
        gestorDeFondo.image("fondoNivel1.png")
        dungeon.dibujar()
        nivel1.dibujar()
    }
}

object gestorDeFondo {
    var property image = "fondoTitulo1.png"

    method position() {
        return game.at(0,0)
    }
}

/////////////indicadorDeObjetos/////////////

object indicadorDeObjetos {

    method position() {
		return game.at(29,23)
	}

	method image() { 
		return "numIndicadorDeObj" + self.imagenSegunEstado() + "-32Bits.png"
	}

    method imagenSegunEstado() {
        if(personaje.bolsa().size()==3) {
            return "3"
        } else if (personaje.bolsa().size()==2) {
            return "2"
        } else if (personaje.bolsa().size()==1) {
            return "1"
        } else {
            return "0"
        }
    }

}

class VisualArmaDeBolsa { //para representar visualmente arriba a la derecha los tipos de arma de las armas del personaje
    const posBolsa

    method image() {
        if (personaje.bolsa().size()>=posBolsa) {
            return self.imagenSiHayArma()
        } else {
            return "empty.png"
        }
    }

    method imagenSiHayArma() {
        const arma = personaje.armaNumero(posBolsa-1)
        return arma.image().replace(".png", "Info.png")
    }

    method position()
}


object primeraArma inherits VisualArmaDeBolsa(posBolsa=1) {

    override method position() {
		return game.at(24,24)
	}

}

object segundaArma inherits VisualArmaDeBolsa(posBolsa=2) {

    override method position() {
		return game.at(26,24)
	}

}

object terceraArma inherits VisualArmaDeBolsa(posBolsa=3) {

    override method position() {
		return game.at(28,24)
	}

}

/////////////indicadorDeObjetos/////////////

/////////////poción////////////////////////

class Pocion {
    const property position //= randomizer.posicionRandomDePocion()
    const property image = "pocion-32Bits.png"

    // El personaje colisiona con la poción y su salud aumenta
    method colisiono(personaje){
        personaje.agregarPocion()
        game.removeVisual(self)
    }

}

object fabricaDePocion {

    method agregarNuevaPocion(_position) {
        const pocion = new Pocion(position = _position)
        game.addVisual(pocion)
    }
    
}


/////////////poción////////////////////////


/////////////objs no traspasable///////////

class ObjetoNoTraspasable  {
    const property position
    

    method image()
    method colisiono(personaje){}    
}

class Barril inherits ObjetoNoTraspasable {
    override method image() {
        return "barriles.png"
    }
}

object fabricaDeBarriles {
    method agregarNuevoBarril(_position) {
        const barriles = new Barril(position = _position)
        game.addVisual(barriles)
        dungeon.registrarObjetoNoTraspasable(barriles)
    }

}

class Caja inherits ObjetoNoTraspasable {
    override method image() {
        return "cajas.png"
    }
}

object fabricaDeCajas {
    method agregarNuevaCaja(_position) {
        const cajas = new Caja(position = _position)
        game.addVisual(cajas)
        dungeon.registrarObjetoNoTraspasable(cajas)
    }

}

class Mesa inherits ObjetoNoTraspasable {
    override method image() {
        return "mesa.png"
    }
}

object fabricaDeMesas {
    method agregarNuevaMesa(_position) {
        const mesa = new Mesa(position = _position)
        game.addVisual(mesa)
        dungeon.registrarObjetoNoTraspasable(mesa)
    }

}

/////////////objs no traspasable///////////

///////barras de arriba con info///////////

object salud {
    method position() { return game.at(1, game.height()-1) }
    method text() { return "salud: " + personaje.salud().toString() }
    method textColor() { return paleta.rojo() }
}

object vidas {
    method position() { return game.at(4, game.height()-1) }

    method image() { 
		return "vidas" + self.imagenSegunEstado() + ".png"
	}

    method imagenSegunEstado() {
        if(personaje.cantVidas()==3) {
            return "3"
        } else if (personaje.cantVidas()==2) {
            return "2"
        } else {
            return "1"
        }
    }

}

object pociones {
    method position() { return game.at(8, game.height()-1) }

    method image() { 
		return "pociones" + self.imagenSegunEstado() + ".png"
	}

    method imagenSegunEstado() {
        if(personaje.cantPociones()==3) {
            return "3"
        } else if (personaje.cantPociones()==2) {
            return "2"
        } else if (personaje.cantPociones()==1) {
            return "1"
        } else {
            return "0"
        }
    }

}

object barraFuerza {
    method position() { return game.at(12, game.height()-1) }

    method image() { 
		return "barraDeFuerza" + self.imagenSegunEstado() + ".png"
	}

    method imagenSegunEstado() {
        if (personaje.fuerzaAcumulada()==5) {
            return "5"
        } else if (personaje.fuerzaAcumulada()==4) {
            return "4"
        } else if(personaje.fuerzaAcumulada()==3) {
            return "3"
        } else if (personaje.fuerzaAcumulada()==2) {
            return "2"
        } else if (personaje.fuerzaAcumulada()==1) {
            return "1"
        } else {
            return "0"
        }
    }
}

///////barras de arriba con info///////////