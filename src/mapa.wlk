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

   const enemigosSpawneados

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
        
        (0..game.width() - 1).forEach({ x =>
            (0..game.height() -1).forEach({y => game.removeVisual(self.tablero().get(y).get(x) )
            })
        })

    }

    method pasarNivel(){
        personaje.pasarNivel()
    }

     method validarPasarNivel(){
        if(!puerta.estaAbierta()){
            self.error("No se puede pasar hasta no matar a todos los enemigos!")
        }
            //self.pasarNivel()
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

object n {
    method dibujarEn(position){
        puerta.dibujarEn(position)
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

    var property position = game.at(1,1) 

    method dibujarEn(_position){
        position = _position
        game.addVisual(self)
    }
    //Suponemos que la puerta esta abierta porque mato a todos los enemigos. Para probar
    method text() = "Puerta"
    method textColor() = paleta.rojo()

    method colisiono(personaje) {
        nivel1.pasarNivel()
        personaje.pasarNivel()

    }

    method estaAbierta(){ //cambiar por estados. Después
        return true
    }
    

}

