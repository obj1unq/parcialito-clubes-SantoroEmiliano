class Club{
	var property actividades = #{}
	var estaSancionado = false
	var cantidadSocios = self.socios().size()
	var socios = #{}
	var gastosMensuales = 0
	
	method sociosEstrellas() = socios.filter({socio => socio.esEstrella(self)})
	
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
			estaSancionado = true
		}
	}
	
	method sancionarActividades(){
		actividades.foreach({actividad => actividad.sancionar()})
	}
	
	method sociosDestacados() =	socios.filter({socio => socio.esDestacado(self)})
	
	method destacadosYEstrellas(){
		return self.sociosDestacados().intersection(self.sociosEstrellas())
	}
	
	method tieneEquipoExperimentado(){
		return actividades.any({actividad => actividad.esExperimentado()})
	}
	
	method esPrestigioso() = self.tieneActConEstrellas() or self.tieneEquipoExperimentado()
	
	
	method tieneActConEstrellas(){
		return actividades.any({actividad => actividad.tieneEstrellas(self)})
	}
	
	method evaluacion() = self.evaluacionBruta() / cantidadSocios 
	
	method evaluacionBruta(){
		return actividades.foreach({actividad => actividad.evaluacion(self)})
	}
	
	method transferencia(unSocio,unEquipo){
		if (not unSocio.esDestacado(self)){
			self.transferir(unSocio,unEquipo)
			self.darBaja(unSocio)
		}
		
	}
	
	method darBaja(unSocio){
		self.actividadesDeSocio(unSocio).foreach({actividad => actividad.quitarParticipante(unSocio)})
		socios.remove(unSocio)
	}
	
	method transferir(unSocio,unEquipo){
		unEquipo.agregarParticipante(unSocio)
	}
	

	
}

class ClubProfesional inherits Club{
	var paseDeEstrella = 0
	
	//retorna true si el pase del socio es mayor a paseDeEstrella
	override method esEstrella(unSocio){
		return super(unSocio) or unSocio.valorPase() > paseDeEstrella
	}
	
	override method evaluacionBruta(){
		return (super() * 2) - (5* gastosMensuales)
	}
	
}

class ClubTradicional inherits Club{
	
	//retorna true si el socio participa en mas de 3 actividades
	override method esEstrella(unSocio){
		return super(unSocio) or self.socioActivo(unSocio)
	}
	
	override method evaluacionBruta(){
		return super() - gastosMensuales
	}
	
}

class ClubComunitario inherits ClubProfesional{
	//retorna true si el socio participa en mas de 3 actividades y tiene un valo de pase mayor a paseEstrella
	override method esEstrella(unSocio){
		return super(unSocio) and self.socioActivo(unSocio)
		
	}
}

class Socio{
	var property aniosAntiguedad = 0
	
	method estrellaPorAntiguedad() = aniosAntiguedad > 20

	method esDestacado(club){
		return	club.actividades().any ({actividad => actividad.organizador() == self})
	}
	
}

class Jugador inherits Socio{
	var property valorPase = 0
	var property partidosJugados = 0
	
	method esExperimentado() = partidosJugados > 10
	
	override method estrellaPorAntiguedad() = partidosJugados > 50
	
	override method esDestacado(club){
		return club.actividades().any({actividad => actividad.capitan()== self})
	}
}




class Actividad {
	var property participantes = #{}
	var estaSancionado = false
	method esExperimentado() = false
	
	method quitarParticipante(unSocio){
		participantes.remove(unSocio)
	}
	
	method agregarParticipante(unSocio){
		participantes.add(unSocio)
	}
	
	method tieneEstrellas(club){
		return participantes.any({participante =>club.esEstrella(participante)})
	}
	
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
	
	override method esExperimentado() = participantes.all({participante => participante.esExperimentado()})
	
	override method sancionar(){
		super()
		sanciones += 1
	}
	
	method sanciones() = sanciones
	
	override method evaluacion(club){
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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	





