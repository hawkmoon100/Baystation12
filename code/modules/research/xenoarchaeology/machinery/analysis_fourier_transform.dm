
obj/machinery/anomaly/fourier_transform
	name = "Fourier Transform spectroscope"

obj/machinery/anomaly/fourier_transform/ScanResults()
	var/results = "The scan was inconclusive. Check sample integrity and carrier consistency."

	var/datum/geosample/scanned_sample
	var/carrier
	var/num_reagents = 0

	for(var/datum/reagent/A in held_container.reagents.reagent_list)
		var/datum/reagent/R = A
		if(istype(R, /datum/reagent/analysis_sample))
			scanned_sample = R.data
		else
			carrier = R.id
		num_reagents++

	if(num_reagents == 2 && scanned_sample && carrier)
		//all necessary components are present
		var/accuracy = GetResultSpecifity(scanned_sample, carrier)
		var/distance = scanned_sample.artifact_distance
		if(distance > 0)
			if(prob(accuracy))
				distance += (2 * rand() - 1) * distance * 0.05
				accuracy = 0.95 + 0.05 * (2 * rand() - 1)
			else
				var/offset = 1 - accuracy
				distance += (2 * rand() - 1) * distance * offset
			results = "Fourier transform analysis on anomalous energy absorption through carrier ([carrier]) indicates source located inside emission radius ([100 * accuracy]% accuracy): [distance]."
		else
			results = "Energy dispersion detected throughout sample consistent with background readings.<br>"
		if(carrier == scanned_sample.source_mineral)
			results += "Warning, analysis may be contaminated by high quantities of molecular carrier present throughout sample."

	return results
