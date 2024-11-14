import wollok.game.*
import personaje.*
import posiciones.*
import pelea.*
import extras.*
import mapa.*

class Enemigo {
    const danhoBase 
    var position
    var salud
    const objetivoADestruir = personaje
    var acumuladorDeTurnos = 0
    const turnoRequeridoParaHabilidad

    method position() {
        return position
    }

    method salud() {
        return salud
    }

    method colisiono(personaje) {
        self.combate() 
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

    //capaz se podría llamar hacerTurno(), porque algunas subclases de enemigo tienen habilidades curativas!
    method atacar() { 
        self.realizarAtaqueNormalOHabilidad() //esto se encarga del ataque/habilidad y de sumar +1 a acumuladorDeTurnos
        combate.cambiarTurnoA(objetivoADestruir)
    }
    
    method recibirDanho(cantidad){
        salud -= cantidad
    }

    method morir() {
        game.removeVisual(self)
        dungeon.enemigos().remove(self)
    }

    method realizarAtaqueNormalOHabilidad() { 
        if(acumuladorDeTurnos < turnoRequeridoParaHabilidad) {
            acumuladorDeTurnos += 1
            objetivoADestruir.recibirDanho(danhoBase)
        } else {
            acumuladorDeTurnos = 0
            self.utilizarHabilidad()
        }
    }

    method image() 
    method reaccionarAMovimiento() 
    //method danhoAtaque()
    //method habilidad()
    method utilizarHabilidad()

    //animacion 
   var estado = 0 
    var animacion = animacionEstatica

    method cambiarAnimacion(){
        //animacion.cambiarEstado()
        estado = (estado + 1) % 4
    }
      
}

object animacionEstatica {

    method estado(){
        return ""
    }

}

object animacionCombate {
    var property estado = "ataque"
    
    method numEstado() {
        return numEstado
    }



}

class OjoVolador inherits Enemigo(turnoRequeridoParaHabilidad = 3) {
    
   override method image() { 
		return "ojoVolador-" + animacion.estado() + estado + "32Bits.png"
	}

    //MOVIMIENTO

    method distanciaEnEjeX() {
        return (objetivoADestruir.position().x() - position.x())
    }

    method distanciaEnEjeY() {
        return (objetivoADestruir.position().y() - position.y())
    }

    override method reaccionarAMovimiento() {
        if (self.distanciaEnEjeX().abs() > self.distanciaEnEjeY().abs()) {
            if(self.distanciaEnEjeX() > 0) {
                const posicionSiguiente = derecha.siguiente(position)
                self.moverseSiNoHayOtroA(posicionSiguiente)
            } else {
                const posicionSiguiente = izquierda.siguiente(position)
                self.moverseSiNoHayOtroA(posicionSiguiente)
            }
        } else if (self.distanciaEnEjeY().abs() > self.distanciaEnEjeX().abs()) {
            if(self.distanciaEnEjeY() > 0) {
                const posicionSiguiente = arriba.siguiente(position)
                self.moverseSiNoHayOtroA(posicionSiguiente)
            } else {
                const posicionSiguiente = abajo.siguiente(position)
                self.moverseSiNoHayOtroA(posicionSiguiente)
            }
        }
    }

    method moverseSiNoHayOtroA(posicionSiguiente) { //El ojo se mueve si no hay otro enemigo en la celda. Así se evitan choques entre ellos.
        if(!dungeon.hayEnemigoEn(posicionSiguiente)) {
            position = posicionSiguiente
        }
    }

    // COMBATE/PELEA

    //el cuarto ataque es habilidad

    override method utilizarHabilidad() {
        game.say(self, "¡Uso habilidad Poción de salud!")
        salud += danhoBase * 2.5
    }

    //movimiento volar
    /*override method cambiarAnimacionEstatica(){
        animacionEstatica.cambiarEstadoOjo()
    }*/

}

class Esqueleto inherits Enemigo(turnoRequeridoParaHabilidad = 4) {
    const vision

    override method image() {
        return "esqueleto-" + animacion.estado() + estado + "32Bits.png" //En realidad es de 64x64
    }

    //MOVIMIENTO (en realidad, no se mueve, pero es lo que hace en vez de moverse)

    override method reaccionarAMovimiento() {

        self.revisarSiHayObjetivo()
    }

    method revisarSiHayObjetivo() {
        if(self.hayObjetivoEnVision() && self.position()!=objetivoADestruir.position()) { //esto para que no se choque con el self.combate() de colisiono()
            position = objetivoADestruir.position()
            self.combate()
        }
    }

    method hayObjetivoEnVision() {
        return vision.hayObjetoEnX(self.position(), objetivoADestruir.position()) &&
               objetivoADestruir.position().y() == self.position().y()
    }

    // COMBATE/PELEA

    //el quinto ataque es habilidad

    override method utilizarHabilidad() {
        game.say(self, "¡Uso habilidad Robo de Energia!")
        salud += danhoBase * 1.5
        objetivoADestruir.recibirDanho(danhoBase * 1.5)
    }

}

/////////objetos visión/////////////

object visionDerecha {

    method hayObjetoEnX(posObservador, posObservado) {
        return posObservado.x().between(posObservador.x(), posObservador.x()+3) //vision.hayObjetoEnX(self.position(), objetivoADestruir.position())
    }

}

object visionIzquierda {

    method hayObjetoEnX(posObservador, posObservado) {
        return posObservado.x().between(posObservador.x()-3, posObservador.x()) //vision.hayObjetoEnX(self.position(), objetivoADestruir.position())
    }

}

class Goblin inherits Enemigo(turnoRequeridoParaHabilidad = 2) {
       
    override method image() {
        return "goblin-" + animacion.estado() + estado +  "32Bits.png" 
    }

    //MOVIMIENTO (en realidad, no se mueve)

    override method reaccionarAMovimiento() { }

    // COMBATE/PELEA

    //el tercer ataque es habilidad

    override method utilizarHabilidad() {
        game.say(self, "¡Uso habilidad Golpe Mortal!")
        objetivoADestruir.recibirDanho(danhoBase * 3)
    }

}

//FACTORIES DE ENEMIGOS
//Tener en cuenta que, de momento, el método que tienen es para crear un enemigo en base a parámetros y no con atributos random.
//para randomizar, si quisiéramos hacerlo, lo haríamos como hicimos en las factories de armas

object fabricaDeOjoVolador {

    method agregarNuevoEnemigo(_position, _salud, _danhoBase) {
        const ojo = new OjoVolador(position = _position, salud = _salud, danhoBase = _danhoBase)
        dungeon.registrarEnemigo(ojo)
        game.addVisual(ojo)
  }
  
}

object fabricaDeEsqueleto {

    method agregarNuevoEnemigo(_position, _salud, _danhoBase, _vision) {
        const esqueleto = new Esqueleto(position = _position, salud = _salud, danhoBase = _danhoBase, vision = _vision)
        dungeon.registrarEnemigo(esqueleto)
        game.addVisual(esqueleto)
  }

}

object fabricaDeGoblin {

    method agregarNuevoEnemigoCon(_position, _salud, _danhoBase) {
        const goblin = new Goblin(position = _position, salud = _salud, danhoBase = _danhoBase)
        dungeon.registrarEnemigo(goblin)
        game.addVisual(goblin)
    }

}
