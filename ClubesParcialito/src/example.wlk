class Club{
	var perfil = unperfil
	var property actividades = #{}
	var estaSancionado = false
	var cantidadSocios = self.socios().size()
	var socios = #{}
	
	method destacadosYEstrellas(){
		return self.sociosDestacados().intersection(self.sociosEstrellas())
	}
	
	method sociosEstrellas() = socios.filter({socio => socio.esEstrella(self)})
	
	method sociosDestacados() =	socios.filter({socio => socio.esDestacado(self)})
	
	method evaluacion() = self.evaluacionBruta() / cantidadSocios 
	
	method evaluacionBruta(){
		return actividades.foreach({actividad => actividad.evaluacion(self)})
	}
	
	method socios(){
		return actividades.map({actividad => actividad.participantes()}).asSet()
	}

	
	
	method esEstrella(unSocio){
		return unSocio.estrellaPorAntiguedad()
	}
	
	//retorna true si el socio participa en mas de 3 actividades
	method socioActivo(unSocio) = self.actividadesDeSocio(unSocio).size() > 3
	
	method actividadesDeSocio(unSocio){
		return actividades.filter({actividad => actividad.participaUnSocio(unSocio) })
	}
	
	method sancionar(){
		if (cantidadSocios>500){
			self.sancionarActividades()
		}
	}
	
	method sancionarActividades(){
		actividades.foreach({actividad => actividad.sancionar()})
	}
	
}

class ClubProfesional inherits Club{
	var paseDeEstrella = 0
	var gastosMensuales = 0
	
	override method evaluacionBruta(){
		return (super() * 2) - (5* gastosMensuales)
	}
	
	//retorna true si el pase del socio es mayor a paseDeEstrella
	override method esEstrella(unSocio){
		return super(unSocio) or unSocio.valorPase() > paseDeEstrella
	}
}

class ClubTradicional inherits Club{
	var gastosMensuales = 0
	
	override method evaluacionBruta(){
		return super() - gastosMensuales
	}
	
	//retorna true si el socio participa en mas de 3 actividades
	override method esEstrella(unSocio){
		return super(unSocio) or self.socioActivo(unSocio)
	}
}

class ClubComunitario inherits ClubProfesional{
	//retorna true si el socio participa en mas de 3 actividades y tiene un valo de pase mayor a paseEstrella
	override method esEstrella(unSocio){
		return super(unSocio) and self.socioActivo(unSocio)
		
	}
}



class Jugador inherits Socio{
	var property valorPase = 0
	var property partidosJugados = 0
	
	override method estrellaPorAntiguedad() = partidosJugados > 50
	
	override method esDestacado(club){
		return club.actividades().any({actividad => actividad.capitan()== self})
	}
}

class Socio{
	var property aniosAntiguedad = 0
	
	method estrellaPorAntiguedad() = aniosAntiguedad > 20

	method esDestacado(club){
		return	club.actividades().any ({actividad => actividad.organizador() == self})
	}
}


class Actividad {
	var property participantes = #{}
	var estaSancionado = false
	
	method participaUnSocio(unSocio) = participantes.any({socio => participantes == unSocio})
}

class ActividadSocial inherits Actividad {
	var property organizador = null
	var property valorSocial = 0
		
	
	method evaluacion(club) {
		return
				if (self.estaSuspendida()){0} else {valorSocial}
	}
	
	method sancionar(){
		estaSancionado  = true
	}
	
	method reanudar(){
		estaSancionado = false
	}
	
	method estaSuspendida() = estaSancionado
}

class Equipo inherits ActividadSocial{
	var property capitan = null
	var sanciones = 0
	var campeonatos = 0
	
	override method sancionar(){
		super()
		sanciones += 1
	}
	
	method sanciones() = sanciones
	
	method evaluacion(club){
		return self.evaluacionGeneral(club) - (sanciones * 20) 
	}
	
	method evaluacionGeneral(club) = (campeonatos * 5) + (participantes * 2) + self.capitanEstrella(club)
	
	method capitanEstrella(club){
		return
			if (club.esEstrella(capitan)) {5} else {0}
	}
}

class EquipoFutbol inherits Equipo{
		override method evaluacion(club){
			return self.evaluacionGeneral(club) + (self.estrellas(club)*5) - (sanciones * 30)
		}
	
		method estrellas(club){
			return	participantes.filter({participante => club.esEstrella(participante)}).size()
		}

}	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	





