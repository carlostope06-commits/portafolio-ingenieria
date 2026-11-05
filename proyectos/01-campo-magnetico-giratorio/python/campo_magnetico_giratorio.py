"""
Campo magnético giratorio en un sistema trifásico (versión Python).

Traducción a Python del script MATLAB original (../matlab/campo_magnetico_giratorio.m)
para poder ejecutarlo sin licencia de MATLAB y generar la animación del README.

Uso:
    pip install numpy matplotlib pillow
    python campo_magnetico_giratorio.py            # genera CampoMagneticoGiratorio.gif
    python campo_magnetico_giratorio.py --f 60     # otra frecuencia
    python campo_magnetico_giratorio.py --inversa  # secuencia de fases inversa
"""
import argparse

import numpy as np
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation, PillowWriter


def main() -> None:
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--imax", type=float, default=12.5, help="Amplitud de las corrientes [A]")
    p.add_argument("--f", type=float, default=50.0, help="Frecuencia [Hz]")
    p.add_argument("--muestras", type=int, default=120, help="Fotogramas por periodo")
    p.add_argument("--inversa", action="store_true", help="Invierte la secuencia de fases")
    p.add_argument("--salida", default="CampoMagneticoGiratorio.gif")
    a = p.parse_args()

    w = 2 * np.pi * a.f
    t = np.linspace(0, 1 / a.f, a.muestras)
    s = -1 if a.inversa else 1

    # Corrientes del sistema trifásico equilibrado
    ia = a.imax * np.sin(w * t)
    ib = a.imax * np.sin(w * t - s * 2 * np.pi / 3)
    ic = a.imax * np.sin(w * t - s * 4 * np.pi / 3)

    # Ejes de las tres bobinas, desfasados 120º en el espacio
    ang = np.array([0, 2 * np.pi / 3, 4 * np.pi / 3])
    bx = ia * np.cos(ang[0]) + ib * np.cos(ang[1]) + ic * np.cos(ang[2])
    by = ia * np.sin(ang[0]) + ib * np.sin(ang[1]) + ic * np.sin(ang[2])

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(11, 5), facecolor="white")
    ax1.plot(t * 1e3, ia, "b", t * 1e3, ib, "m", t * 1e3, ic, "g", lw=1.5)
    ax1.set(xlabel="Tiempo [ms]", ylabel="Corriente [A]", title="Corrientes trifásicas")
    ax1.legend(["ia", "ib", "ic"], loc="upper right")
    ax1.grid(True)
    cursor = ax1.axvline(0, color="k", lw=1, ls="--")

    lim = 1.6 * 1.5 * a.imax
    ax2.set(xlim=(-lim, lim), ylim=(-lim, lim), aspect="equal", title="Vector de inducción magnética")
    ax2.grid(True)
    for th in ang:  # ejes de las bobinas
        ax2.plot([0, lim * np.cos(th)], [0, lim * np.sin(th)], color="0.8", lw=1)
    ax2.plot(bx, by, color="0.6", ls=":", lw=1)  # trayectoria (circunferencia de radio 1.5·Imax)
    flecha = ax2.quiver(0, 0, bx[0], by[0], angles="xy", scale_units="xy", scale=1, color="r", width=0.012)

    def actualizar(k):
        flecha.set_UVC(bx[k], by[k])
        cursor.set_xdata([t[k] * 1e3] * 2)
        return flecha, cursor

    anim = FuncAnimation(fig, actualizar, frames=len(t), blit=False)
    anim.save(a.salida, writer=PillowWriter(fps=30))
    print(f"Guardado {a.salida}  |  módulo |B| = {np.hypot(bx, by).mean():.2f} (teórico 1.5·Imax = {1.5 * a.imax:.2f})")


if __name__ == "__main__":
    main()
