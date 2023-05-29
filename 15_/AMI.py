import jpype
import numpy as np
import atexit
import os
from tqdm.auto import tqdm




# jarLocation = os.environ['DOC'] + "/JIDT/infodynamics.jar"
jarLocation = os.path.join(os.getenv('DOC'), 'JIDT', 'infodynamics.jar')
print(jarLocation)
# jarLocation = "/Users/muuzh/Documents/JIDT/infodynamics.jar"
# jpype.startJVM(jpype.getDefaultJVMPath(), "-ea", "-Djava.class.path=" + jarLocation)
class JvmManager:
    def __init__(self):
        if not jpype.isJVMStarted():
            jpype.startJVM(jpype.getDefaultJVMPath(), "-ea", "-Djava.class.path=" + jarLocation)

    def shutdown(self):
        if jpype.isJVMStarted():
            jpype.shutdownJVM()

jvm_manager = JvmManager()

# Register the shutdown function to be called when the interpreter exits
atexit.register(jvm_manager.shutdown)

def automutual_info_single(x, timelag, k=3):
    global jvm_manager
    teCalcClass = jpype.JPackage("infodynamics.measures.continuous.kraskov").MutualInfoCalculatorMultiVariateKraskov2
    miCalc = teCalcClass()
    miCalc.setProperty('k', str(k))
    miCalc.initialise(1, 1)
    x1 = x[:-timelag]
    x2 = x[timelag:]
    miCalc.setObservations(x1, x2)
    ami = miCalc.computeAverageLocalOfObservations()
    return ami


def compute_mi(y, timelag, miCalc, progress_bar):
    miCalc.initialise(1, 1)
    y1 = y[:-timelag]
    y2 = y[timelag:]
    miCalc.setObservations(y1, y2)
    ami = miCalc.computeAverageLocalOfObservations()
    progress_bar.update(1)
    return ami


def automutual_info(x_matrix, timelag, k=3):
    global jvm_manager
    teCalcClass = jpype.JPackage("infodynamics.measures.continuous.kraskov").MutualInfoCalculatorMultiVariateKraskov2
    # now working with an array with given shape, assume the last dimension is for series
    # i.e. (a_num, series_length), (a_num, sample_num, series_length)
    # AMIresult = np.full(x_matrix.shape[0], np.nan)
    miCalc = teCalcClass()
    miCalc.setProperty('k',str(k))

    total_iterations = np.prod(x_matrix.shape[:-1])
    with tqdm(total=total_iterations, desc="Processing") as progress_bar:
        AMIresult = np.apply_along_axis(compute_mi, axis=-1, arr=x_matrix, timelag=timelag, miCalc=miCalc, progress_bar=progress_bar)
    return AMIresult

def automutual_info_k1(x_matrix, timelag, k=3):
    global jvm_manager
    teCalcClass = jpype.JPackage("infodynamics.measures.continuous.kraskov").MutualInfoCalculatorMultiVariateKraskov1
    # now working with an array with given shape, assume the last dimension is for series
    # i.e. (a_num, series_length), (a_num, sample_num, series_length)
    # AMIresult = np.full(x_matrix.shape[0], np.nan)
    miCalc = teCalcClass()
    miCalc.setProperty('k',str(k))

    total_iterations = np.prod(x_matrix.shape[:-1])
    with tqdm(total=total_iterations, desc="Processing") as progress_bar:
        AMIresult = np.apply_along_axis(compute_mi, axis=-1, arr=x_matrix, timelag=timelag, miCalc=miCalc, progress_bar=progress_bar)
    return AMIresult