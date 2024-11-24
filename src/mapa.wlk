import wollok.game.*
import posiciones.*
import extras.*
import paleta.*
import enemigos.*
import armas.*
import randomizer.*
import pelea.*
import personaje.*
import niveles.*

object mapa {
    //podemos hacer const tablero que represente todas las celdas del tablero y eso usarlo para dibujar los distintos elementos del mismo.
    //Eso lo usaríamos para dibujar cada elemento en su posición con un método para dibujar todas las celdas del tablero y métodos
    //individuales que dibujen los distintos objetos (onda, uno para arma, uno para enemigo) (como hizo Leo en clase hace un tiempo)

    /* esto es ineficiente!
    method limpiar() {
        (0..game.width()-1).forEach({ x =>
            (0..game.height()-1).forEach({ y =>
                game.getObjectsIn(game.at(x,y)).forEach({obj => if(!self.estaEnOrigin(obj.position())) {game.removeVisual(obj)} })
            })
        })
    }
    */

    method limpiar() {
        game.allVisuals().forEach({vis => if(!self.estaEnOrigin(vis.position())) {game.removeVisual(vis)} })
    }

    method estaEnOrigin(pos) {
        return pos == game.at(0,0)
    }

}

class Nivel {

   const property enemigosSpawneados

    method tablero()
        /* [
        [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
        [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
        [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
        [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
        [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
        [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
        [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
        [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
        [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
        [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
        [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
        [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
        [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
        [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
        [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
        [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
        [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
        [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
        [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
        [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
        [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
        [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
        [x,x,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x,x],
        [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x],
        [x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x]

            ].reverse() */
    

    method dibujar() {
        game.height(self.tablero().size())
        game.width(self.tablero().get(0).size())


        (0..game.width() - 1).forEach({ x =>
            (0..game.height() -1).forEach({y =>
                self.tablero().get(y).get(x).dibujarEn(game.at(x,y))
            })
        })
       
    }


    method limpiarTablero() {
        game.height(self.tablero().size())
        game.width(self.tablero().get(0).size())
        
        game.allVisuals().forEach( { visual => game.removeVisual(visual)})

        dungeon.dibujar()
    }

    method pasarNivel(){
        //personaje.pasarNivel()
        dungeon.cerraPuerta()
        dungeon.siguienteNivel()
        self.limpiarTablero()
    }

    } 



object a { //arma
    method dibujarEn(position){
       //fabricaDeArcoYFlecha.agregarNuevaArma(_position)
       randomizer.agregarArmaRandom(position)
    }
}

object o { // ojo
    method dibujarEn(position){
        fabricaDeOjoVolador.agregarNuevoEnemigo(position,150, 40)
    }

}

object g { // goblin
    method dibujarEn(position){
        fabricaDeGoblin.agregarNuevoEnemigoCon(position, 95, 37)
    }
}

object e{ //esqueleto
    method dibujarEn(position){
        fabricaDeEsqueleto.agregarNuevoEnemigo(position, 200, 43,  visionDerecha)
    }
}

object p { //pocion de salud
    method dibujarEn(position){
        fabricaDePocion.agregarNuevaPocion(position)
    }
}


object _ { // donde se pueden poner cosas
    method dibujarEn(_position){

    }
}

object x { //donde no se pueden poner cosas porque ahi pared
       method dibujarEn(_position){

    }
}


object enemigosAsesinadosNivelActual {
    method position() = game.at(27,22)
    method text() = "Asesinados: " + personaje.enemigosAsesinados().toString()
    method textColor() = paleta.rojo()
}

object puerta {

    method position() =  game.at(15,19) 
    var estado = puertaCerrada

    //Suponemos que la puerta esta abierta porque mato a todos los enemigos. Para probar
    method text() = "Puerta"
    method textColor() = paleta.rojo()

    method colisiono(personaje) {
        self.validarEntrar()
        personaje.pasarNivel()

    }

    method abrirPuerta(){
        estado = puertaAbierta
    }

    method validarEntrar(){
        if(!estado.sePuedePasar()){
            self.error("Se deben matar a todos lo enemigos!")
        }
    }


    method reiniciarPuerta(){
        estado = puertaCerrada
    }



    

}

object puertaAbierta {
    method sePuedePasar(){
        return true
    }
}


object puertaCerrada {
    method sePuedePasar(){
        return false
    }
}