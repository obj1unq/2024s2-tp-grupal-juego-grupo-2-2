import wollok.game.*
import posiciones.*
import extras.*
import paleta.*
import enemigos.*
import personaje.*

object combate {

    var property entidadAtacando = null //aquel que tiene el turno para atacar
    const heroe = personaje
    var hayCombate = false

    method iniciarCombate(){
        heroe.enemigoCombatiendo(entidadAtacando)
        hayCombate = true
        heroe.estaEnCombate(true)   //en personaje se puede poner combate.hayCombate() en vez de mandarle esto al personaje
        barraEstadoPeleas.enemigo(entidadAtacando)
        barraEstadoPeleas.aparecerJuntoADemasBarras()
    }

    method cambiarTurnoA(entidad){
        entidadAtacando = entidad
        //game.schedule(500, {self.entidadAtaca()} ) //quedaba lindo pero acumula daño
        self.entidadAtaca() //acá se valida si el que ahora tiene el turno sigue con vida y, si es así, este realiza su ataque
    }

    method entidadAtaca() {
        self.validarFinDeCombate()
        self.validarCombate()
        entidadAtacando.atacarPre()
    }

    method validarFinDeCombate() {
        if(entidadAtacando.vida() <= 0) {
            hayCombate = false
            heroe.estaEnCombate(false)
            barraEstadoPeleas.desaparecerJuntoADemasBarras()
            entidadAtacando.morir()
        }
    }

    method validarCombate() {
        if(!hayCombate){
            self.error("No hay nadie peleando")
        }
    }
    method hayCombate(cond){
        hayCombate = cond
    }

}

object barraEstadoPeleas {

    var property enemigo = null
    var property heroe = personaje

    method text() = "Barra De Peleas"
    method textColor() = paleta.rojo()

    method position() = game.at(7, heroe.position().y() - 3)

    // aparece todo lo que tiene que mostrar la barra de estado
    method aparecerJuntoADemasBarras() {
            game.addVisual(self)
            game.addVisual(vidaPersonaje)
            game.addVisual(vidaEnemigo)
            game.addVisual(ataque)
            //game.addVisual(turnoTest)
    }

    // desaparece la barra y todo lo que muestra tras darse la muerte del personaje o el enemigo
    method desaparecerJuntoADemasBarras() {
        game.removeVisual(self)
        game.removeVisual(vidaPersonaje)
        game.removeVisual(vidaEnemigo)
        game.removeVisual(ataque)
        //game.removeVisual(turnoTest)
    }

}

object vidaPersonaje{

    method text() = "Vida: " + personaje.vida().toString()
        method textColor() = paleta.rojo()

    method position() = barraEstadoPeleas.position().down(1).left(2)

}

object vidaEnemigo {

    method text() = " Vida enemigo: " + barraEstadoPeleas.enemigo().vida().toString()
    method textColor() = paleta.rojo()

    method position() = vidaPersonaje.position().right(3)

}

object ataque{

    method position() = vidaPersonaje.position().down(1).right(2)
    method text() = "Durabilidad (" +personaje.armaActual().toString() + "): " + personaje.armaActual().durabilidad().toString() //+ "\n Nivel: " + personaje.armaActual().nivel().toString()
    method textColor() = paleta.rojo()

}

object turnoTest {
    method position() = game.at(1,16)//ataque.position().right(5)
    method text() = "Turno De: " + combate.entidadAtacando()
    method textColor() = paleta.rojo()


}