import wollok.game.*
import personaje.*
import posiciones.*
import pelea.*
import randomizer.*
import extras.*


class Enemigo {
    var position
    var vida
    const objetivoADestruir = personaje

    method position() {
        return position
    }

    method image() 
    method estado() 

    method colisiono(personaje) {
     self.combate() 
    }
    
    method vida() {
        return vida
    }

    method combate() {
        combate.entidadAtacando(self)   //Hace saber al combate que él(enemigo/self) será quien empieza
        combate.iniciarCombate()    //prepara toda el hud del combate y la info necesaria

        position = position.right(1)    //se posiciona una celda a la derecha del personaje
        game.say(self, "Ah! Pelea!")    // Avisa . Despues se va a quitar

        combate.cambiarTurnoA(self) //Empieza el combate
    }
      
    method atacarPre() {
      self.atacar()
    }

    method atacar()
    //method habilidad()
    
    method recibirDanho(cantidad){
        vida = vida - cantidad
    }

    method mover() 
    method morir()

      
}

class OjoVolador inherits Enemigo {

   override  method image() { //image() se calcula a cada frame al igual que position(), si no entendí mal
		return "ojito32a.png"
        //return "enemigo1" + self.estado().imagenParaPersonaje() + "-32Bits.png"
	}

	override method estado() {
		return ojoSinArma //como, de momento, tiene un solo estado, es un poco raro. Tendrá mas sentido si tiene más estados (como el pj)
	}

    //MOVIMIENTO

    method distanciaEnEjeX() {
        return (objetivoADestruir.position().x() - position.x())
    }

    method distanciaEnEjeY() {
        return (objetivoADestruir.position().y() - position.y())
    }

   override method mover() {   // SI HAY MAS DE UN ENEMIGO QUE NO SE METAN LOS DOS EN LA MISMA CELDA
        if (self.distanciaEnEjeX().abs() > self.distanciaEnEjeY().abs()) {
            if(self.distanciaEnEjeX() > 0) {
                const posicionSiguiente = derecha.siguiente(position)
                self.validarMover(posicionSiguiente)
                position = posicionSiguiente
            } else {
                const posicionSiguiente = izquierda.siguiente(position)
                self.validarMover(posicionSiguiente)
                position = posicionSiguiente
            }
        } else if (self.distanciaEnEjeY().abs() > self.distanciaEnEjeX().abs()) {
            if(self.distanciaEnEjeY() > 0) {
                const posicionSiguiente = arriba.siguiente(position)
                self.validarMover(posicionSiguiente)
                position = posicionSiguiente
            } else {
                const posicionSiguiente = abajo.siguiente(position)
                self.validarMover(posicionSiguiente)
                position = posicionSiguiente
            }
        }
    }

    method validarMover(celda) {
        if(dungeon.hayEnemigoEn(celda)){
            self.error("Ocupado")
        }
    }

    // COMBATE/PELEA

   override method atacar() {
        objetivoADestruir.recibirDanho(20) //FUTURO: Hacer las habilidades del enemigo y hacerlo clase
        combate.cambiarTurnoA(objetivoADestruir)
    }

   override method morir() {
        /*Este método despues se va cambiar por un removeVisual o algo asi, esta así ahora para testear porque solo tenemos un enemigo.*/
        position = game.at(7,4)
        vida = 150
    }

}

class Esqueleto inherits Enemigo {

    //const rangoDeVisionX = [1,2,3,4,5,6,7]

    var condicionMovimiento

    override method image() {
        return "esqueleto" + self.estado().imagenParaPersonaje() + "-32Bits.png"
    }

    override method estado() {
        return esqueletoSinArma
    }

    override method mover() {
           self.encontrarObjetivo()
    }


    //quiero que el "colisiono" en el esqueleto adquiera el hayObjetivoEnVision
    //para que cuando pase el personaje por esas posiciones de x empiece el combate
    //pero en este colisiono en particular me dice que esta malformado
    /*override method colisiono(personaje) {
        if (hayObjetivoEnVision()) {
            self.combate()
        }
    }*/     
    method encontrarObjetivo(){
        self.validarEncontrar()
        position = objetivoADestruir.position()

    }

    method validarEncontrar(){
        if(!self.hayObjetivoEnVision(condicionMovimiento)){
            self.error("No hay objetivo")
        }
    }

    method hayObjetivoEnVision(condicion) {
        return condicion
    }

    override method atacar() {
        objetivoADestruir.recibirDanho(43) //FUTURO: Hacer las habilidades del enemigo
        combate.cambiarTurnoA(objetivoADestruir)
    }

   override method morir() {
        game.removeVisual(self)
    }

}

class Goblin inherits Enemigo {
    
    override method image() {
        return "enemigo1" + self.estado().imagenParaPersonaje() + "-32Bits.png"
    }

    override method estado() {
        return goblinSinArma
    }

    override method mover() {
           
    }

    method hayObjetivoEnVision() {
        return objetivoADestruir.position().x().between(4, 7)
    }

    override method atacar() {
        objetivoADestruir.recibirDanho(37) //FUTURO: Hacer las habilidades del enemigo
        combate.cambiarTurnoA(objetivoADestruir)
    }

    override method morir() {
        game.removeVisual(self)
    }    
}

object fabricaDeOjos {

    method nuevoEnemigo() {
        const ojo = new OjoVolador(position = game.at(14,12) , vida = 150) 
        dungeon.spawnEnemigo(ojo)
        return ojo
  }
}

object fabricaDeEsqueleto {

    method nuevoEnemigo() {
        const esqueleto = new Esqueleto(position = game.at(3,10) , vida = 200, condicionMovimiento = personaje.position().x().between(4, 7) && personaje.position().y() == 10) 
        dungeon.spawnEnemigo(esqueleto)
        return esqueleto
  }
}

object fabricaDeEsqueleto2 {

    method nuevoEnemigo() {
        return new Esqueleto(position = game.at(26,13) , vida = 200)
  }
}

object ojoSinArma {

    method imagenParaPersonaje() {
        return ""
    }
}

object esqueletoSinArma {

    method imagenParaPersonaje() {
      return ""
    }
}

object goblinSinArma {

    method imagenParaPersonaje() {
        return ""
    }
}

