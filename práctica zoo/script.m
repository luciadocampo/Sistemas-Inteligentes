clear all;
entradas = xlsread ("PonAquiTuArchivo.xlsx", 'Entradas RNA')';
salidasDeseadas = xlsread ("PonAquiTuArchivo.xlsx", 'Salidas RNA')';

arquitecturas = { [], [3], [5], [10], [15], [5 3], [8 3], [8 5], [10 5]};


for i = 1:length(arquitecturas)
    arquitectura = arquitecturas{i};

    precisionEntrenamiento = [];
    precisionValidacion = [];
    precisionTest = [];
    for j=1:50
        rna = patternnet(arquitectura);
        rna.trainParam.showWindow=true;
        [rna, tr] = train(rna, entradas, salidasDeseadas);
        salidasRNA = sim(rna,entradas);

        precisionEntrenamiento(end+1) = 1-confusion(salidasDeseadas(:, tr.trainInd), salidasRNA(:,tr.trainInd));
        precisionValidacion(end+1) = 1-confusion(salidasDeseadas(:, tr.valInd), salidasRNA(:,tr.valInd));
        precisionTest(end+1) = 1-confusion(salidasDeseadas(:, tr.testInd), salidasRNA(:,tr.testInd));
    end
   
    fprintf('Arquitectura [%s], Entrenamientos: %2.f%% (%.2f), validacion %.2f%% (%.2f), test %2.f%% (%.2f)\n', sprintf('%d ', arquitectura), 100 * mean(precisionEntrenamiento), std(precisionEntrenamiento), 100 * mean(precisionValidacion), std(precisionValidacion),100 * mean(precisionTest), std(precisionTest));
end