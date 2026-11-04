from manimlib import *
#from manimlib.config import manim_config
#manim_config.tex.template = "basic_ctex"
import numpy as np

RT_LABEL = 0.5

BD_W = 2
BD_W_SEL = 8

SZ_DEFAULT = 0.4
SZ_SMALL_POLY = 0.35
SZ_SMALL = 0.25
SZ_SMALLER = 0.15
SZ_ZOOM_RIGHT = 0.75
SZ_ZOOM_MID = 1.25

SCALE_DEFAULT = 0.6
SCALE_SMALLER = 0.4

FONT_DEFAULT = "Segoe UI"
FONT_LATEX = "Segoe UI"

SCALE_LATEX = 1.0
SCALE_SUBTITLE = 1.25
SCALE_TITLE = 1.65
SCALE_CENTER = 0.66
SCALE_CENTER_URL = 0.55
SCALE_CENTER_INDENT = 0.45

REF_TEX = "N\\times N"
ADD_TEX = "<c0>Qy<cI>"

FONT_COLOR_BLACK = "#333333"
FONT_SIZE_DEFAULT = 32
FONT_SIZE_LARGE = 48
FONT_SIZE_SMALL = 24

HL_COLOR_1 = "#ff3333"
HL_COLOR_2 = "#ffff00"

L_COLOR  = "#55aaff"
E_COLOR  = "#55aaff"
B_COLOR  = "#ff55aa"
Y_COLOR  = "#ffff55"
H_COLOR  = "#55aaff"
V_COLOR  = "#aa55ff"
I_COLOR  = "#ffffff"
K_COLOR  = "#55ff55"
F_COLOR  = "#55ddff"
C_COLOR  = "#55ffaa"
P_COLOR  = "#aa55ff"
Q_COLOR  = "#ff55ff"
G_COLOR  = "#ffaaff"
R_COLOR  = "#ffffaa"
Z_COLOR  = "#ff7755"
D_COLOR  = "#aaffff"
X_COLOR  = "#ffaa55"
T_COLOR  = "#ffffaa"

COLOR_MAP = {
    "cH1": HL_COLOR_1,
    "cH2": HL_COLOR_2,
    "cL":  L_COLOR,
    "cE":  E_COLOR,
    "cB":  B_COLOR,
    "cY":  Y_COLOR,
    "cH":  H_COLOR,
    "cV":  V_COLOR,
    "cI":  I_COLOR,
    "cK":  K_COLOR,
    "cF":  F_COLOR,
    "cC":  C_COLOR,
    "cP":  P_COLOR,
    "cQ":  Q_COLOR,
    "cG":  G_COLOR,
    "cR":  R_COLOR,
    "cZ":  Z_COLOR,
    "cD":  D_COLOR,
    "cX":  X_COLOR,
    "cT":  T_COLOR,
    "c0":  FONT_COLOR_BLACK,
}

def make_grid(scene, w, h, lgt_x=0.0, btn_x=0.0, lgt_y=0.0, btn_y=0.0, btn_c=B_COLOR, lgt_c=L_COLOR, sz=SZ_DEFAULT, rt=0.3, mat=None, mat_l=None, w_l=None, h_l=None, show=True, mat_g=None):
    w_l = w if w_l is None else int(w_l)
    h_l = h if h_l is None else int(h_l)
    lgt = [[False for _ in range(w_l)] for _ in range(h_l)]
    btn = [[False for _ in range(w)] for _ in range(h)]
    lgt_sel = [[False for _ in range(w_l)] for _ in range(h_l)]
    btn_sel = [[False for _ in range(w)] for _ in range(h)]
    grid_vis_lgt = [[True for _ in range(w_l)] for _ in range(h_l)]
    grid_vis_btn = [[True for _ in range(w)] for _ in range(h)]
    def _apply_mask_from(mat_mask, target, W, H):
        if mat_mask is None: return
        if isinstance(mat_mask, dict):
            _apply_mask_from(mat_mask.get("lgt"), grid_vis_lgt, w_l, h_l)
            _apply_mask_from(mat_mask.get("btn"), grid_vis_btn, w, h)
            return
        mh = len(mat_mask)
        mw = len(mat_mask[0]) if mh > 0 else 0
        Hm = min(H, mh)
        Wm = min(W, mw)
        for j in range(Hm):
            for i in range(Wm):
                v = mat_mask[j][i]
                show_cell = not (v == 0 or (isinstance(v, (int, float)) and v <= -1))
                target[j][i] = bool(show_cell)
    _apply_mask_from(mat_g, grid_vis_lgt, w_l, h_l)
    _apply_mask_from(mat_g, grid_vis_btn, w, h)
    if mat is not None:
        mh=len(mat)
        mw=len(mat[0]) if mh>0 else 0
        H=min(h,mh)
        W=min(w,mw)
        for j in range(H):
            for i in range(W):
                v=int(mat[j][i])
                if v<=-1:
                    grid_vis_btn[j][i]=False
                    if i<w_l and j<h_l: grid_vis_lgt[j][i]=False
    if mat_l is not None:
        lh=len(mat_l)
        lw=len(mat_l[0]) if lh>0 else 0
        H2=min(h_l,lh)
        W2=min(w_l,lw)
        for j in range(H2):
            for i in range(W2):
                v=int(mat_l[j][i])
                if v<=-1:
                    grid_vis_lgt[j][i]=False
                    if i<w and j<h: grid_vis_btn[j][i]=False
    lgt_start_x = -(w_l - 1) * sz / 2.0
    lgt_start_y =  (h_l - 1) * sz / 2.0
    btn_start_x = -(w   - 1) * sz / 2.0
    btn_start_y =  (h   - 1) * sz / 2.0
    lgt_shift = np.array([lgt_x, lgt_y, 0.0])
    btn_shift = np.array([btn_x, btn_y, 0.0])
    lgt_bd_base_grp = VGroup()
    btn_bd_base_grp = VGroup()
    lgt_bd_hl_grp   = VGroup()
    btn_bd_hl_grp   = VGroup()
    lgt_sp_grp      = VGroup()
    btn_sp_grp      = VGroup()
    lgt_sz = 0.85 * sz
    btn_sz = 0.7 * sz / 2.0
    lgt_bd_base = [[None] * w_l for _ in range(h_l)]
    lgt_bd_hl   = [[None] * w_l for _ in range(h_l)]
    lgt_sp      = [[None] * w_l for _ in range(h_l)]
    btn_bd_base = [[None] * w   for _ in range(h)]
    btn_bd_hl   = [[None] * w   for _ in range(h)]
    btn_sp      = [[None] * w   for _ in range(h)]
    for j in range(h_l):
        for i in range(w_l):
            center = np.array([lgt_start_x + i * sz, lgt_start_y - j * sz, 0.0])
            lbd = Square(side_length=sz).set_fill(opacity=0).set_stroke(WHITE, BD_W, 0)
            lbd.move_to(center + lgt_shift)
            if not grid_vis_lgt[j][i]: lbd.set_stroke(opacity=0)
            lgt_bd_base[j][i]=lbd
            lgt_bd_base_grp.add(lbd)
            lbd_hl = lbd.copy().set_stroke(HL_COLOR_1, BD_W_SEL, 0).set_fill(opacity=0)
            if not grid_vis_lgt[j][i]: lbd_hl.set_stroke(opacity=0)
            lgt_bd_hl[j][i]=lbd_hl
            lgt_bd_hl_grp.add(lbd_hl)
            lsp = Square(side_length=lgt_sz).set_stroke(width=0, opacity=0).set_fill(lgt_c,1)
            lsp.move_to(center + lgt_shift)
            if not grid_vis_lgt[j][i]: lsp.set_opacity(0)
            lgt_sp[j][i]=lsp
            lgt_sp_grp.add(lsp)
    for j in range(h):
        for i in range(w):
            center = np.array([btn_start_x + i * sz, btn_start_y - j * sz, 0.0])
            bbd = Square(side_length=sz).set_fill(opacity=0).set_stroke(WHITE, BD_W, 0)
            bbd.move_to(center + btn_shift)
            if not grid_vis_btn[j][i]: bbd.set_stroke(opacity=0)
            btn_bd_base[j][i]=bbd
            btn_bd_base_grp.add(bbd)
            bbd_hl = bbd.copy().set_stroke(HL_COLOR_1, BD_W_SEL, 0).set_fill(opacity=0)
            if not grid_vis_btn[j][i]: bbd_hl.set_stroke(opacity=0)
            btn_bd_hl[j][i]=bbd_hl
            btn_bd_hl_grp.add(bbd_hl)
            bsp = Circle(radius=btn_sz).set_stroke(width=0, opacity=0).set_fill(btn_c,1)
            bsp.move_to(center + btn_shift)
            if not grid_vis_btn[j][i]: bsp.set_opacity(0)
            btn_sp[j][i]=bsp
            btn_sp_grp.add(bsp)
    if mat is not None:
        mh = len(mat)
        mw = len(mat[0]) if mh > 0 else 0
        H = min(h, mh)
        W = min(w, mw)
        for j in range(H):
            for i in range(W):
                v=int(mat[j][i])
                if v<=-1: continue
                if v == 1:
                    btn[j][i] = True
                    for (x, y) in ((i, j), (i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1)):
                        if 0<=x<w_l and 0<=y<h_l: lgt[y][x]=not lgt[y][x]
    if mat_l is not None:
        lh = len(mat_l)
        lw = len(mat_l[0]) if lh > 0 else 0
        H2 = min(h_l, lh)
        W2 = min(w_l, lw)
        for j in range(H2):
            for i in range(W2):
                v=int(mat_l[j][i])
                if v<=-1: continue
                lgt[j][i]=bool(v)
    for j in range(h_l):
        for i in range(w_l):
            lgt_sp[j][i].set_opacity(1 if (lgt[j][i] and grid_vis_lgt[j][i]) else 0)
    for j in range(h):
        for i in range(w):
            btn_sp[j][i].set_opacity(1 if (btn[j][i] and grid_vis_btn[j][i]) else 0)
    if show:
        scene.add(
            lgt_bd_base_grp,
            btn_bd_base_grp,
            lgt_sp_grp,
            btn_sp_grp,
            btn_bd_hl_grp,
            lgt_bd_hl_grp,
        )
        if rt > 0:
            vis_lgt_bd = VGroup(*[lgt_bd_base[j][i] for j in range(h_l) for i in range(w_l) if grid_vis_lgt[j][i]])
            vis_btn_bd = VGroup(*[btn_bd_base[j][i] for j in range(h) for i in range(w) if grid_vis_btn[j][i]])
            if len(vis_lgt_bd)>0 or len(vis_btn_bd)>0:
                anims=[]
                if len(vis_lgt_bd)>0: anims.append(vis_lgt_bd.animate.set_stroke(opacity=1))
                if len(vis_btn_bd)>0: anims.append(vis_btn_bd.animate.set_stroke(opacity=1))
                scene.play(*anims, run_time=rt)
        else:
            VGroup(*[lgt_bd_base[j][i] for j in range(h_l) for i in range(w_l) if grid_vis_lgt[j][i]]).set_stroke(opacity=1)
            VGroup(*[btn_bd_base[j][i] for j in range(h) for i in range(w) if grid_vis_btn[j][i]]).set_stroke(opacity=1)
    else:
        VGroup(*[lgt_bd_base[j][i] for j in range(h_l) for i in range(w_l) if grid_vis_lgt[j][i]]).set_stroke(opacity=1)
        VGroup(*[btn_bd_base[j][i] for j in range(h) for i in range(w) if grid_vis_btn[j][i]]).set_stroke(opacity=1)
    return {
        "lgt": lgt,
        "btn": btn,
        "lgt_sel": lgt_sel,
        "btn_sel": btn_sel,
        "lgt_bd_base": lgt_bd_base,
        "btn_bd_base": btn_bd_base,
        "lgt_bd_hl": lgt_bd_hl,
        "btn_bd_hl": btn_bd_hl,
        "lgt_sp": lgt_sp,
        "btn_sp": btn_sp,
        "grid_vis_lgt": grid_vis_lgt,
        "grid_vis_btn": grid_vis_btn,
        "groups": {
            "lgt_bd_base": lgt_bd_base_grp,
            "btn_bd_base": btn_bd_base_grp,
            "lgt_bd_hl": lgt_bd_hl_grp,
            "btn_bd_hl": btn_bd_hl_grp,
            "lgt_sp": lgt_sp_grp,
            "btn_sp": btn_sp_grp,
        },
        "params": {
            "w": w,
            "h": h,
            "w_l": w_l,
            "h_l": h_l,
            "sz": sz,
            "lgt_x": lgt_x,
            "lgt_y": lgt_y,
            "btn_x": btn_x,
            "btn_y": btn_y,
            "mat": mat,
            "mat_l": mat_l,
            "mat_g": mat_g,
        },
    }

def trans_grid(scene, A_from, A_to, rt=0.8, keep_from=False, target_override=None, extra_anims=None, B_from=None, B_to=None, B_target_override=None, B_extra_anims=None):
    if A_to["groups"]["lgt_bd_base"].get_stroke_opacity() == 0:
        A_to["groups"]["lgt_bd_base"].set_stroke(opacity=1)
    if A_to["groups"]["btn_bd_base"].get_stroke_opacity() == 0:
        A_to["groups"]["btn_bd_base"].set_stroke(opacity=1)
    if B_to is not None:
        if B_to["groups"]["lgt_bd_base"].get_stroke_opacity() == 0:
            B_to["groups"]["lgt_bd_base"].set_stroke(opacity=1)
        if B_to["groups"]["btn_bd_base"].get_stroke_opacity() == 0:
            B_to["groups"]["btn_bd_base"].set_stroke(opacity=1)
    def composite(G):
        return VGroup(
            G["groups"]["lgt_sp"],
            G["groups"]["lgt_bd_base"],
            G["groups"]["btn_sp"],
            G["groups"]["btn_bd_base"],
        )
    grp_from_A = composite(A_from).copy() if keep_from else composite(A_from)
    grp_to_A = target_override if target_override is not None else composite(A_to)
    if keep_from:
        scene.add(grp_from_A)
    anims = [ReplacementTransform(grp_from_A, grp_to_A)]
    grp_from_B = None
    grp_to_B = None
    if B_from is not None and B_to is not None:
        grp_from_B = composite(B_from).copy() if keep_from else composite(B_from)
        grp_to_B = B_target_override if B_target_override is not None else composite(B_to)
        if keep_from:
            scene.add(grp_from_B)
        anims.append(ReplacementTransform(grp_from_B, grp_to_B))
    if extra_anims:
        anims.extend(extra_anims)
    if B_extra_anims:
        anims.extend(B_extra_anims)
    scene.play(*anims, run_time=rt)
    if target_override is not None:
        try:
            scene.remove(grp_to_A)
        except Exception:
            pass
    if B_to is not None and B_target_override is not None and grp_to_B is not None:
        try:
            scene.remove(grp_to_B)
        except Exception:
            pass
    scene.add(A_to["groups"]["lgt_bd_hl"])
    scene.add(A_to["groups"]["btn_bd_hl"])
    if B_to is not None:
        scene.add(B_to["groups"]["lgt_bd_hl"])
        scene.add(B_to["groups"]["btn_bd_hl"])
    try:
        scene.bring_to_front(A_to["groups"]["lgt_bd_hl"])
        scene.bring_to_front(A_to["groups"]["btn_bd_hl"])
        if B_to is not None:
            scene.bring_to_front(B_to["groups"]["lgt_bd_hl"])
            scene.bring_to_front(B_to["groups"]["btn_bd_hl"])
    except Exception:
        pass
    if not keep_from:
        if B_from is not None:
            del_grids(scene, [A_from, B_from], rt=0.0)
        else:
            del_grids(scene, A_from, rt=0.0)

def add_grid(scene, A_from, A_to, B_from=None, B_to=None, rt=0.8, keep_from=True):
    ht_btn_A, wt_btn_A = A_to["params"]["h"], A_to["params"]["w"]
    hf_btn_A, wf_btn_A = A_from["params"]["h"], A_from["params"]["w"]
    ht_lgt_A = A_to["params"].get("h_l", ht_btn_A)
    wt_lgt_A = A_to["params"].get("w_l", wt_btn_A)
    hf_lgt_A = A_from["params"].get("h_l", hf_btn_A)
    wf_lgt_A = A_from["params"].get("w_l", wf_btn_A)
    btn_x_A = [[0] * wt_btn_A for _ in range(ht_btn_A)]
    for j in range(ht_btn_A):
        for i in range(wt_btn_A):
            b0 = 1 if A_to["btn"][j][i] else 0
            b1 = 1 if (j < hf_btn_A and i < wf_btn_A and A_from["btn"][j][i]) else 0
            btn_x_A[j][i] = b0 ^ b1
    lgt_x_A = [[0] * wt_lgt_A for _ in range(ht_lgt_A)]
    for j in range(ht_lgt_A):
        for i in range(wt_lgt_A):
            l0 = 1 if A_to["lgt"][j][i] else 0
            l1 = 1 if (j < hf_lgt_A and i < wf_lgt_A and A_from["lgt"][j][i]) else 0
            lgt_x_A[j][i] = l0 ^ l1
    lgt_sp_final_A = []
    for j in range(ht_lgt_A):
        for i in range(wt_lgt_A):
            m1 = A_to["lgt_sp"][j][i].copy()
            m1.set_opacity(1.0 if lgt_x_A[j][i] else 0.0)
            lgt_sp_final_A.append(m1)
    btn_sp_final_A = []
    for j in range(ht_btn_A):
        for i in range(wt_btn_A):
            m2 = A_to["btn_sp"][j][i].copy()
            m2.set_opacity(1.0 if btn_x_A[j][i] else 0.0)
            btn_sp_final_A.append(m2)
    grp_final_A = VGroup(
        VGroup(*lgt_sp_final_A),
        A_to["groups"]["lgt_bd_base"].copy(),
        VGroup(*btn_sp_final_A),
        A_to["groups"]["btn_bd_base"].copy(),
    )
    anims_A = []
    for j in range(ht_lgt_A):
        for i in range(wt_lgt_A):
            _queue_opacity_anim(A_to["lgt_sp"][j][i], 1.0 if lgt_x_A[j][i] else 0.0, anims_A)
    for j in range(ht_btn_A):
        for i in range(wt_btn_A):
            _queue_opacity_anim(A_to["btn_sp"][j][i], 1.0 if btn_x_A[j][i] else 0.0, anims_A)
    if B_from is not None and B_to is not None:
        ht_btn_B, wt_btn_B = B_to["params"]["h"], B_to["params"]["w"]
        hf_btn_B, wf_btn_B = B_from["params"]["h"], B_from["params"]["w"]
        ht_lgt_B = B_to["params"].get("h_l", ht_btn_B)
        wt_lgt_B = B_to["params"].get("w_l", wt_btn_B)
        hf_lgt_B = B_from["params"].get("h_l", hf_btn_B)
        wf_lgt_B = B_from["params"].get("w_l", wf_btn_B)
        btn_x_B = [[0] * wt_btn_B for _ in range(ht_btn_B)]
        for j in range(ht_btn_B):
            for i in range(wt_btn_B):
                b0 = 1 if B_to["btn"][j][i] else 0
                b1 = 1 if (j < hf_btn_B and i < wf_btn_B and B_from["btn"][j][i]) else 0
                btn_x_B[j][i] = b0 ^ b1
        lgt_x_B = [[0] * wt_lgt_B for _ in range(ht_lgt_B)]
        for j in range(ht_lgt_B):
            for i in range(wt_lgt_B):
                l0 = 1 if B_to["lgt"][j][i] else 0
                l1 = 1 if (j < hf_lgt_B and i < wf_lgt_B and B_from["lgt"][j][i]) else 0
                lgt_x_B[j][i] = l0 ^ l1
        lgt_sp_final_B = []
        for j in range(ht_lgt_B):
            for i in range(wt_lgt_B):
                m1 = B_to["lgt_sp"][j][i].copy()
                m1.set_opacity(1.0 if lgt_x_B[j][i] else 0.0)
                lgt_sp_final_B.append(m1)
        btn_sp_final_B = []
        for j in range(ht_btn_B):
            for i in range(wt_btn_B):
                m2 = B_to["btn_sp"][j][i].copy()
                m2.set_opacity(1.0 if btn_x_B[j][i] else 0.0)
                btn_sp_final_B.append(m2)
        grp_final_B = VGroup(
            VGroup(*lgt_sp_final_B),
            B_to["groups"]["lgt_bd_base"].copy(),
            VGroup(*btn_sp_final_B),
            B_to["groups"]["btn_bd_base"].copy(),
        )
        anims_B = []
        for j in range(ht_lgt_B):
            for i in range(wt_lgt_B):
                _queue_opacity_anim(B_to["lgt_sp"][j][i], 1.0 if lgt_x_B[j][i] else 0.0, anims_B)
        for j in range(ht_btn_B):
            for i in range(wt_btn_B):
                _queue_opacity_anim(B_to["btn_sp"][j][i], 1.0 if btn_x_B[j][i] else 0.0, anims_B)
        trans_grid(scene, A_from, A_to, rt=rt, keep_from=keep_from, target_override=grp_final_A, extra_anims=anims_A, B_from=B_from, B_to=B_to, B_target_override=grp_final_B, B_extra_anims=anims_B)
        for j in range(ht_btn_B):
            for i in range(wt_btn_B):
                B_to["btn"][j][i] = bool(btn_x_B[j][i])
                B_to["btn_sp"][j][i].set_opacity(1.0 if btn_x_B[j][i] else 0.0)
        for j in range(ht_lgt_B):
            for i in range(wt_lgt_B):
                B_to["lgt"][j][i] = bool(lgt_x_B[j][i])
                B_to["lgt_sp"][j][i].set_opacity(1.0 if lgt_x_B[j][i] else 0.0)
    else:
        trans_grid(scene, A_from, A_to, rt=rt, keep_from=keep_from, target_override=grp_final_A, extra_anims=anims_A)
    for j in range(ht_btn_A):
        for i in range(wt_btn_A):
            A_to["btn"][j][i] = bool(btn_x_A[j][i])
            A_to["btn_sp"][j][i].set_opacity(1.0 if btn_x_A[j][i] else 0.0)
    for j in range(ht_lgt_A):
        for i in range(wt_lgt_A):
            A_to["lgt"][j][i] = bool(lgt_x_A[j][i])
            A_to["lgt_sp"][j][i].set_opacity(1.0 if lgt_x_A[j][i] else 0.0)

def swap_grid(scene, A_from, A_to, B_from=None, B_to=None, rt=0.8):
    gA, gB = A_from["groups"], A_to["groups"]
    dA_l = gB["lgt_sp"].get_center() - gA["lgt_sp"].get_center()
    dA_b = gB["btn_sp"].get_center() - gA["btn_sp"].get_center()
    dB_l = -dA_l
    dB_b = -dA_b
    lgt_sp_A = gA["lgt_sp"]
    lgt_sp_B = gB["lgt_sp"]
    btn_sp_A = gA["btn_sp"]
    btn_sp_B = gB["btn_sp"]
    lgt_color_A = lgt_sp_A[0].get_fill_color() if len(lgt_sp_A) > 0 else None
    lgt_color_B = lgt_sp_B[0].get_fill_color() if len(lgt_sp_B) > 0 else None
    btn_color_A = btn_sp_A[0].get_fill_color() if len(btn_sp_A) > 0 else None
    btn_color_B = btn_sp_B[0].get_fill_color() if len(btn_sp_B) > 0 else None
    anims = []
    a_lgt_anim = lgt_sp_A.animate.shift(dA_l)
    b_lgt_anim = lgt_sp_B.animate.shift(dB_l)
    a_btn_anim = btn_sp_A.animate.shift(dA_b)
    b_btn_anim = btn_sp_B.animate.shift(dB_b)
    if lgt_color_B is not None: a_lgt_anim = a_lgt_anim.set_fill(lgt_color_B)
    if lgt_color_A is not None: b_lgt_anim = b_lgt_anim.set_fill(lgt_color_A)
    if btn_color_B is not None: a_btn_anim = a_btn_anim.set_fill(btn_color_B)
    if btn_color_A is not None: b_btn_anim = b_btn_anim.set_fill(btn_color_A)
    anims.extend([
        a_lgt_anim,
        gA["lgt_bd_base"].animate.shift(dA_l),
        gA["lgt_bd_hl"].animate.shift(dA_l),
        a_btn_anim,
        gA["btn_bd_base"].animate.shift(dA_b),
        gA["btn_bd_hl"].animate.shift(dA_b),
        b_lgt_anim,
        gB["lgt_bd_base"].animate.shift(dB_l),
        gB["lgt_bd_hl"].animate.shift(dB_l),
        b_btn_anim,
        gB["btn_bd_base"].animate.shift(dB_b),
        gB["btn_bd_hl"].animate.shift(dB_b),
    ])
    frA = A_from.get("extras", {}).get("outer_frames", [])
    frB = A_to.get("extras", {}).get("outer_frames", [])
    if frA:
        if len(frA) >= 1: anims.append(frA[0].animate.shift(dA_l))
        if len(frA) >= 2: anims.append(frA[1].animate.shift(dA_b))
    if frB:
        if len(frB) >= 1: anims.append(frB[0].animate.shift(dB_l))
        if len(frB) >= 2: anims.append(frB[1].animate.shift(dB_b))
    if B_from is not None and B_to is not None:
        gC, gD = B_from["groups"], B_to["groups"]
        dC_l = gD["lgt_sp"].get_center() - gC["lgt_sp"].get_center()
        dC_b = gD["btn_sp"].get_center() - gC["btn_sp"].get_center()
        dD_l = -dC_l
        dD_b = -dC_b
        lgt_sp_C = gC["lgt_sp"]
        lgt_sp_D = gD["lgt_sp"]
        btn_sp_C = gC["btn_sp"]
        btn_sp_D = gD["btn_sp"]
        lgt_color_C = lgt_sp_C[0].get_fill_color() if len(lgt_sp_C) > 0 else None
        lgt_color_D = lgt_sp_D[0].get_fill_color() if len(lgt_sp_D) > 0 else None
        btn_color_C = btn_sp_C[0].get_fill_color() if len(btn_sp_C) > 0 else None
        btn_color_D = btn_sp_D[0].get_fill_color() if len(btn_sp_D) > 0 else None
        c_lgt_anim = lgt_sp_C.animate.shift(dC_l)
        d_lgt_anim = lgt_sp_D.animate.shift(dD_l)
        c_btn_anim = btn_sp_C.animate.shift(dC_b)
        d_btn_anim = btn_sp_D.animate.shift(dD_b)
        if lgt_color_D is not None: c_lgt_anim = c_lgt_anim.set_fill(lgt_color_D)
        if lgt_color_C is not None: d_lgt_anim = d_lgt_anim.set_fill(lgt_color_C)
        if btn_color_D is not None: c_btn_anim = c_btn_anim.set_fill(btn_color_D)
        if btn_color_C is not None: d_btn_anim = d_btn_anim.set_fill(btn_color_C)
        anims.extend([
            c_lgt_anim,
            gC["lgt_bd_base"].animate.shift(dC_l),
            gC["lgt_bd_hl"].animate.shift(dC_l),
            c_btn_anim,
            gC["btn_bd_base"].animate.shift(dC_b),
            gC["btn_bd_hl"].animate.shift(dC_b),
            d_lgt_anim,
            gD["lgt_bd_base"].animate.shift(dD_l),
            gD["lgt_bd_hl"].animate.shift(dD_l),
            d_btn_anim,
            gD["btn_bd_base"].animate.shift(dD_b),
            gD["btn_bd_hl"].animate.shift(dD_b),
        ])
        frC = B_from.get("extras", {}).get("outer_frames", [])
        frD = B_to.get("extras", {}).get("outer_frames", [])
        if frC:
            if len(frC) >= 1: anims.append(frC[0].animate.shift(dC_l))
            if len(frC) >= 2: anims.append(frC[1].animate.shift(dC_b))
        if frD:
            if len(frD) >= 1: anims.append(frD[0].animate.shift(dD_l))
            if len(frD) >= 2: anims.append(frD[1].animate.shift(dD_b))
    if anims: scene.play(*anims, run_time=rt)
    tmp = A_from.copy()
    A_from.clear()
    A_from.update(A_to)
    A_to.clear()
    A_to.update(tmp)
    if B_from is not None and B_to is not None:
        tmp2 = B_from.copy()
        B_from.clear()
        B_from.update(B_to)
        B_to.clear()
        B_to.update(tmp2)
    try:
        objs = [
            A_from["groups"]["lgt_bd_hl"],
            A_from["groups"]["btn_bd_hl"],
            A_to["groups"]["lgt_bd_hl"],
            A_to["groups"]["btn_bd_hl"],
        ]
        if B_from is not None and B_to is not None:
            objs.extend([
                B_from["groups"]["lgt_bd_hl"],
                B_from["groups"]["btn_bd_hl"],
                B_to["groups"]["lgt_bd_hl"],
                B_to["groups"]["btn_bd_hl"],
            ])
        scene.bring_to_front(*objs)
    except Exception:
        pass

def addshift_grid(scene, A_from, A_to, B_from=None, B_to=None, k=1, rt=0.8):
    if k < 0: return
    ht_lgt_A = A_to["params"].get("h_l", A_to["params"]["h"])
    wt_lgt_A = A_to["params"].get("w_l", A_to["params"]["w"])
    hf_lgt_A = A_from["params"].get("h_l", A_from["params"]["h"])
    wf_lgt_A = A_from["params"].get("w_l", A_from["params"]["w"])
    new_lgt_A = [[False]*wt_lgt_A for _ in range(ht_lgt_A)]
    for j in range(ht_lgt_A):
        for i in range(wt_lgt_A):
            v = bool(A_to["lgt"][j][i])
            src = i - k
            if 0 <= src < wf_lgt_A and j < hf_lgt_A and A_from["lgt"][j][src]:
                v = not v
            new_lgt_A[j][i] = v
    new_lgt_B = None
    if B_from is not None and B_to is not None:
        ht_lgt_B = B_to["params"].get("h_l", B_to["params"]["h"])
        wt_lgt_B = B_to["params"].get("w_l", B_to["params"]["w"])
        hf_lgt_B = B_from["params"].get("h_l", B_from["params"]["h"])
        wf_lgt_B = B_from["params"].get("w_l", B_from["params"]["w"])
        new_lgt_B = [[False]*wt_lgt_B for _ in range(ht_lgt_B)]
        for j in range(ht_lgt_B):
            for i in range(wt_lgt_B):
                v = bool(B_to["lgt"][j][i])
                src = i - k
                if 0 <= src < wf_lgt_B and j < hf_lgt_B and B_from["lgt"][j][src]:
                    v = not v
                new_lgt_B[j][i] = v
    anims = []
    movers = []
    for j in range(min(hf_lgt_A, ht_lgt_A)):
        for src in range(wf_lgt_A):
            if not A_from["lgt"][j][src]: continue
            dest = src + k
            if 0 <= dest < wt_lgt_A and j < ht_lgt_A:
                bd = A_from["lgt_bd_base"][j][src].copy()
                sp = A_from["lgt_sp"][j][src].copy()
                m = VGroup(bd, sp)
                m.set_opacity(1.0)
                scene.add(m)
                movers.append(m)
                a = m.animate.move_to(A_to["lgt_sp"][j][dest].get_center()).set_opacity(0.0)
                anims.append(a)
    if B_from is not None and B_to is not None and new_lgt_B is not None:
        for j in range(min(hf_lgt_B, ht_lgt_B)):
            for src in range(wf_lgt_B):
                if not B_from["lgt"][j][src]: continue
                dest = src + k
                if 0 <= dest < wt_lgt_B and j < ht_lgt_B:
                    bd = B_from["lgt_bd_base"][j][src].copy()
                    sp = B_from["lgt_sp"][j][src].copy()
                    m = VGroup(bd, sp)
                    m.set_opacity(1.0)
                    scene.add(m)
                    movers.append(m)
                    a = m.animate.move_to(B_to["lgt_sp"][j][dest].get_center()).set_opacity(0.0)
                    anims.append(a)
    for j in range(ht_lgt_A):
        for i in range(wt_lgt_A):
            target = 1.0 if new_lgt_A[j][i] else 0.0
            _queue_opacity_anim(A_to["lgt_sp"][j][i], target, anims)
    if B_from is not None and B_to is not None and new_lgt_B is not None:
        for j in range(ht_lgt_B):
            for i in range(wt_lgt_B):
                target = 1.0 if new_lgt_B[j][i] else 0.0
                _queue_opacity_anim(B_to["lgt_sp"][j][i], target, anims)
    if anims:
        scene.play(*anims, run_time=rt)
    for m in movers:
        try:
            scene.remove(m)
        except Exception:
            pass
    for j in range(ht_lgt_A):
        for i in range(wt_lgt_A):
            A_to["lgt"][j][i] = bool(new_lgt_A[j][i])
            A_to["lgt_sp"][j][i].set_opacity(1.0 if new_lgt_A[j][i] else 0.0)
    if B_from is not None and B_to is not None and new_lgt_B is not None:
        for j in range(ht_lgt_B):
            for i in range(wt_lgt_B):
                B_to["lgt"][j][i] = bool(new_lgt_B[j][i])
                B_to["lgt_sp"][j][i].set_opacity(1.0 if new_lgt_B[j][i] else 0.0)

def shift_grid(scene, A_from, B_from=None, k=1, rt=0.3):
    if k <= 0: return
    ht_lgt_A = A_from["params"].get("h_l", A_from["params"]["h"])
    wt_lgt_A = A_from["params"].get("w_l", A_from["params"]["w"])
    new_lgt_A = [[False]*wt_lgt_A for _ in range(ht_lgt_A)]
    for j in range(ht_lgt_A):
        for i in range(wt_lgt_A):
            src = i - k
            v = False
            if 0 <= src < wt_lgt_A:
                v = bool(A_from["lgt"][j][src])
            new_lgt_A[j][i] = v
    if B_from is not None:
        ht_lgt_B = B_from["params"].get("h_l", B_from["params"]["h"])
        wt_lgt_B = B_from["params"].get("w_l", B_from["params"]["w"])
        new_lgt_B = [[False]*wt_lgt_B for _ in range(ht_lgt_B)]
        for j in range(ht_lgt_B):
            for i in range(wt_lgt_B):
                src = i - k
                v = False
                if 0 <= src < wt_lgt_B:
                    v = bool(B_from["lgt"][j][src])
                new_lgt_B[j][i] = v
    anims = []
    for j in range(ht_lgt_A):
        for i in range(wt_lgt_A):
            target = 1.0 if new_lgt_A[j][i] else 0.0
            _queue_opacity_anim(A_from["lgt_sp"][j][i], target, anims)
    if B_from is not None:
        for j in range(ht_lgt_B):
            for i in range(wt_lgt_B):
                target = 1.0 if new_lgt_B[j][i] else 0.0
                _queue_opacity_anim(B_from["lgt_sp"][j][i], target, anims)
    if anims:
        scene.play(*anims, run_time=rt)
    for j in range(ht_lgt_A):
        for i in range(wt_lgt_A):
            A_from["lgt"][j][i] = bool(new_lgt_A[j][i])
            A_from["lgt_sp"][j][i].set_opacity(1.0 if new_lgt_A[j][i] else 0.0)
    if B_from is not None:
        for j in range(ht_lgt_B):
            for i in range(wt_lgt_B):
                B_from["lgt"][j][i] = bool(new_lgt_B[j][i])
                B_from["lgt_sp"][j][i].set_opacity(1.0 if new_lgt_B[j][i] else 0.0)

def move_grid(scene, G, lgt_x=0.0, btn_x=0.0, lgt_y=0.0, btn_y=0.0, rt=0.8, sz=None):
    px = G["params"].get("lgt_x", 0.0)
    py = G["params"].get("lgt_y", 0.0)
    qx = G["params"].get("btn_x", 0.0)
    qy = G["params"].get("btn_y", 0.0)
    dlgt = np.array([lgt_x - px, lgt_y - py, 0.0])
    dbtn = np.array([btn_x - qx, btn_y - qy, 0.0])
    lg=G["groups"]
    lgt_targets=[lg["lgt_bd_base"],lg["lgt_bd_hl"],lg["lgt_sp"]]
    btn_targets=[lg["btn_bd_base"],lg["btn_bd_hl"],lg["btn_sp"]]
    if "lgt_group" not in lg: lg["lgt_group"]=VGroup(*lgt_targets)
    if "btn_group" not in lg: lg["btn_group"]=VGroup(*btn_targets)
    lgt_group=lg["lgt_group"]
    btn_group=lg["btn_group"]
    k=1.0
    if sz is not None:
        cur_sz = G["params"].get("size", G["params"].get("sz", SZ_DEFAULT))
        cur_sz = max(float(cur_sz), 1e-12)
        k = sz / cur_sz
    need_scale=abs(k-1.0)>1e-9
    need_move=(np.linalg.norm(dlgt)>1e-9) or (np.linalg.norm(dbtn)>1e-9)
    if rt>0 and (need_scale or need_move):
        tl=lgt_group.copy()
        tb=btn_group.copy()
        if need_scale:
            tl.scale(k)
            tb.scale(k)
        if np.linalg.norm(dlgt)>1e-9: tl.shift(dlgt)
        if np.linalg.norm(dbtn)>1e-9: tb.shift(dbtn)
        scene.play(Transform(lgt_group,tl),Transform(btn_group,tb),run_time=rt)
    else:
        if need_scale:
            lgt_group.scale(k)
            btn_group.scale(k)
        if np.linalg.norm(dlgt)>1e-9: lgt_group.shift(dlgt)
        if np.linalg.norm(dbtn)>1e-9: btn_group.shift(dbtn)
    G["params"]["lgt_x"] = lgt_x
    G["params"]["lgt_y"] = lgt_y
    G["params"]["btn_x"] = btn_x
    G["params"]["btn_y"] = btn_y
    if sz is not None: G["params"]["size"]=sz

def toggle_grid(scene, G, i, j, which="both", to=None, rt=0.3):
    anims=[]
    def _apply_one(kind, i, j, vis_to):
        if kind=="lgt":
            if not (0<=j<len(G["grid_vis_lgt"]) and 0<=i<len(G["grid_vis_lgt"][0])): return
            cur=G["grid_vis_lgt"][j][i]
            new= (not cur) if to is None else bool(to)
            G["grid_vis_lgt"][j][i]=new
            bd=G["lgt_bd_base"][j][i]
            hl=G["lgt_bd_hl"][j][i]
            sp=G["lgt_sp"][j][i]
            sp.set_stroke(width=0, opacity=0)
            if new:
                bd.set_fill(opacity=0)
                sp.set_fill(L_COLOR, 1)
                t_bd = 1.0
                t_hl = 1.0 if G["lgt_sel"][j][i] else 0.0
                if G["lgt"][j][i]:
                    if rt > 0 and scene is not None:
                        anims.append(sp.animate.set_opacity(1.0))
                    else:
                        sp.set_opacity(1.0)
                else:
                    sp.set_opacity(0.0)
            else:
                t_bd = 0.0
                t_hl = 0.0
                sp.set_opacity(0.0)
            if rt > 0 and scene is not None:
                anims.append(bd.animate.set_stroke(opacity=t_bd))
                anims.append(hl.animate.set_stroke(opacity=t_hl))
            else:
                bd.set_stroke(opacity=t_bd)
                hl.set_stroke(opacity=t_hl)
        else:
            if not (0<=j<len(G["grid_vis_btn"]) and 0<=i<len(G["grid_vis_btn"][0])): return
            cur=G["grid_vis_btn"][j][i]
            new= (not cur) if to is None else bool(to)
            G["grid_vis_btn"][j][i]=new
            bd=G["btn_bd_base"][j][i]
            hl=G["btn_bd_hl"][j][i]
            sp=G["btn_sp"][j][i]
            sp.set_stroke(width=0, opacity=0)
            if new:
                bd.set_fill(opacity=0)
                sp.set_fill(B_COLOR, 1)
                t_bd = 1.0
                t_hl = 1.0 if G["btn_sel"][j][i] else 0.0
                if G["btn"][j][i]:
                    if rt > 0 and scene is not None:
                        anims.append(sp.animate.set_opacity(1.0))
                    else:
                        sp.set_opacity(1.0)
                else:
                    sp.set_opacity(0.0)
            else:
                t_bd = 0.0
                t_hl = 0.0
                sp.set_opacity(0.0)
            if rt > 0 and scene is not None:
                anims.append(bd.animate.set_stroke(opacity=t_bd))
                anims.append(hl.animate.set_stroke(opacity=t_hl))
            else:
                bd.set_stroke(opacity=t_bd)
                hl.set_stroke(opacity=t_hl)
    if which in ("lgt","both"): _apply_one("lgt",i,j,to)
    if which in ("btn","both"): _apply_one("btn",i,j,to)
    if rt>0 and anims: scene.play(*anims, run_time=rt)

def toggle_lgt(scene, G, i, j, rt=0.3):
    G["lgt"][j][i] = not G["lgt"][j][i]
    m = G["lgt_sp"][j][i]
    m.set_stroke(width=0, opacity=0)
    vis = True
    if "grid_vis_lgt" in G and 0<=j<len(G["grid_vis_lgt"]) and 0<=i<len(G["grid_vis_lgt"][0]):
        vis = G["grid_vis_lgt"][j][i]
    target = 1 if (G["lgt"][j][i] and vis) else 0
    if scene is not None and rt>0:
        scene.play(m.animate.set_opacity(target), run_time=rt)
    else:
        m.set_opacity(target)

def toggle_btn(scene, G, i, j, rt=0.3):
    G["btn"][j][i] = not G["btn"][j][i]
    m = G["btn_sp"][j][i]
    m.set_stroke(width=0, opacity=0)
    vis = True
    if "grid_vis_btn" in G and 0<=j<len(G["grid_vis_btn"]) and 0<=i<len(G["grid_vis_btn"][0]):
        vis = G["grid_vis_btn"][j][i]
    target = 1 if (G["btn"][j][i] and vis) else 0
    if scene is not None and rt>0:
        scene.play(m.animate.set_opacity(target), run_time=rt)
    else:
        m.set_opacity(target)

def set_bd(G, kind, i, j, selected):
    if kind == "lgt":
        G["lgt_sel"][j][i] = selected
        vis=True
        if "grid_vis_lgt" in G and 0<=j<len(G["grid_vis_lgt"]) and 0<=i<len(G["grid_vis_lgt"][0]):
            vis=G["grid_vis_lgt"][j][i]
        G["lgt_bd_hl"][j][i].set_stroke(opacity=1 if (selected and vis) else 0)
        return
    G["btn_sel"][j][i] = selected
    vis=True
    if "grid_vis_btn" in G and 0<=j<len(G["grid_vis_btn"]) and 0<=i<len(G["grid_vis_btn"][0]):
        vis=G["grid_vis_btn"][j][i]
    G["btn_bd_hl"][j][i].set_stroke(opacity=1 if (selected and vis) else 0)

def clear_all_bd(G):
    w = G["params"]["w"]
    h = G["params"]["h"]
    for j in range(h):
        for i in range(w):
            if G["lgt_sel"][j][i]:
                G["lgt_sel"][j][i] = False
                G["lgt_bd_hl"][j][i].set_stroke(opacity=0)
            if G["btn_sel"][j][i]:
                G["btn_sel"][j][i] = False
                G["btn_bd_hl"][j][i].set_stroke(opacity=0)

def hl_bd(scene, grids, color=HL_COLOR_1, width=BD_W_SEL, buff=0.03, rt=0.3):
    if isinstance(grids, dict):
        gs = [[grids]]
    else:
        gs = grids if isinstance(grids[0], list) else [grids]
    root_group = VGroup()
    for y in range(len(gs)):
        for x in range(len(gs[y])):
            G = gs[y][x]
            root_group.add(G["groups"]["lgt_bd_base"], G["groups"]["btn_bd_base"])
    bd = (
        SurroundingRectangle(root_group, buff=buff)
        .set_fill(opacity=0)
        .set_stroke(color, width, 1)
    )
    scene.add(bd)
    scene.play(FadeIn(bd), run_time=rt)
    return bd

def del_bd(scene, bd, rt=0.3):
    if bd is None:
        return
    scene.play(FadeOut(bd), run_time=rt)
    try:
        scene.remove(bd)
    except Exception:
        pass

def hl_cells(scene, grids, indices=[(0, 0)], color=HL_COLOR_1, width=BD_W_SEL, rt=0.3, **kwargs):
    if not hasattr(scene, "_hl_cells_group") or scene._hl_cells_group is None:
        scene._hl_cells_group = VGroup()
        scene._hl_cells_map = {}
        scene.add(scene._hl_cells_group)
    grp = scene._hl_cells_group
    mp = scene._hl_cells_map
    glist = grids if isinstance(grids, list) else [grids]
    anims = []
    for G in glist:
        bd = (G.get("lgt_bd_base") if isinstance(G, dict) else None) or (G.get("btn_bd_base") if isinstance(G, dict) else None)
        if bd is None:
            continue
        h = len(bd)
        w = len(bd[0]) if h > 0 else 0
        for (i, j) in indices:
            if not (0 <= j < h and 0 <= i < w):
                continue
            k = (id(G), i, j)
            if k in mp:
                m = mp[k]
                anims.append(m.animate.set_stroke(color=color, width=width, opacity=1))
            else:
                m = bd[j][i].copy().set_fill(opacity=0).set_stroke(color=color, width=width, opacity=0)
                mp[k] = m
                grp.add(m)
                anims.append(m.animate.set_stroke(color=color, width=width, opacity=1))
    scene.bring_to_front(grp)
    if anims:
        scene.play(*anims, run_time=rt)
        scene.bring_to_front(grp)

def del_cells(scene, grids, indices=None, rt=0.3, **kwargs):
    grp = getattr(scene, "_hl_cells_group", None)
    mp = getattr(scene, "_hl_cells_map", None)
    if grp is None or mp is None:
        return
    glist = grids if isinstance(grids, list) else [grids]
    if indices is None:
        targets = list(grp.submobjects)
        mp.clear()
    else:
        targets = []
        for G in glist:
            for (i, j) in indices:
                k = (id(G), i, j)
                m = mp.pop(k, None)
                if m is not None:
                    targets.append(m)
    if not targets:
        return
    scene.play(*[m.animate.set_stroke(opacity=0) for m in targets], run_time=rt)
    for m in targets:
        if m in grp.submobjects:
            grp.remove(m)
        scene.remove(m)
    if len(grp.submobjects) == 0:
        scene.remove(grp)
        delattr(scene, "_hl_cells_group")
        delattr(scene, "_hl_cells_map")

def add_cell(scene, G_from, G_to, sx, sy, tx, ty, rt=0.3, color_from=None, color_to=None):
    ht_lgt_to = G_to["params"].get("h_l", G_to["params"]["h"])
    wt_lgt_to = G_to["params"].get("w_l", G_to["params"]["w"])
    hf_btn_from = G_from["params"]["h"]
    wf_btn_from = G_from["params"]["w"]
    if not (0 <= sx < wf_btn_from and 0 <= sy < hf_btn_from):
        return
    if not (0 <= tx < wt_lgt_to and 0 <= ty < ht_lgt_to):
        return
    do_hl = scene is not None and (color_from is not None or color_to is not None)
    h_btn_to = G_to["params"]["h"]
    w_btn_to = G_to["params"]["w"]
    if do_hl:
        if color_from is not None:
            hl_cells(scene, [G_from], indices=[(sx, sy)], color=color_from, rt=rt)
        if color_to is not None and 0 <= tx < w_btn_to and 0 <= ty < h_btn_to:
            hl_cells(scene, [G_to], indices=[(tx, ty)], color=color_to, rt=rt)
    G_to["lgt"][ty][tx] = not G_to["lgt"][ty][tx]
    m_target = G_to["lgt_sp"][ty][tx]
    m_target.set_stroke(width=0, opacity=0)
    vis_to = True
    if "grid_vis_lgt" in G_to and 0 <= ty < len(G_to["grid_vis_lgt"]) and 0 <= tx < len(G_to["grid_vis_lgt"][0]):
        vis_to = G_to["grid_vis_lgt"][ty][tx]
    target_op = 1.0 if (G_to["lgt"][ty][tx] and vis_to) else 0.0
    if scene is not None and rt > 0:
        m_btn_src = G_from["btn_sp"][sy][sx].copy()
        m_lgt_src = G_from["lgt_sp"][sy][sx].copy()
        moving = VGroup(m_lgt_src, m_btn_src)
        vis_btn_from = True
        if "grid_vis_btn" in G_from and 0 <= sy < len(G_from["grid_vis_btn"]) and 0 <= sx < len(G_from["grid_vis_btn"][0]):
            vis_btn_from = G_from["grid_vis_btn"][sy][sx]
        op_btn_from = 1.0 if vis_btn_from else 0.0
        vis_lgt_from = True
        if "grid_vis_lgt" in G_from and 0 <= sy < len(G_from["grid_vis_lgt"]) and 0 <= sx < len(G_from["grid_vis_lgt"][0]):
            vis_lgt_from = G_from["grid_vis_lgt"][sy][sx]
        op_lgt_from = 1.0 if (G_from["lgt"][sy][sx] and vis_lgt_from) else 0.0
        m_btn_src.set_opacity(op_btn_from)
        m_lgt_src.set_opacity(op_lgt_from)
        scene.add(moving)
        try:
            frames_to = G_to.get("extras", {}).get("outer_frames", [])
        except Exception:
            frames_to = []
        try:
            frames_from = G_from.get("extras", {}).get("outer_frames", [])
        except Exception:
            frames_from = []
        try:
            if frames_from:
                scene.bring_to_front(*frames_from)
            if frames_to:
                scene.bring_to_front(*frames_to)
        except Exception:
            pass
        try:
            scene.bring_to_front(
                G_to["groups"]["lgt_bd_hl"],
                G_to["groups"]["btn_bd_hl"],
                G_from["groups"]["lgt_bd_hl"],
                G_from["groups"]["btn_bd_hl"],
            )
        except Exception:
            pass
        scene.play(
            moving.animate.move_to(m_target.get_center()).set_opacity(0.0),
            m_target.animate.set_opacity(target_op),
            run_time=rt,
        )
        try:
            scene.remove(moving)
        except Exception:
            pass
    else:
        m_target.set_opacity(target_op)

    if do_hl:
        if color_from is not None:
            del_cells(scene, [G_from], indices=[(sx, sy)], rt=rt)
        if color_to is not None and 0 <= tx < w_btn_to and 0 <= ty < h_btn_to:
            del_cells(scene, [G_to], indices=[(tx, ty)], rt=rt)

def hl_objs(scene, objs, color=HL_COLOR_1, width=BD_W_SEL, buff=0.03, rt=0.3):
    stack = [objs]
    targets, seen = [], set()
    while stack:
        cur = stack.pop()
        if cur is None:
            continue
        if isinstance(cur, (list, tuple)):
            stack.extend(cur)
        elif isinstance(cur, Mobject):
            i = id(cur)
            if i not in seen:
                seen.add(i)
                targets.append(cur)
    if not targets:
        return []
    targets.reverse()
    frames = []
    for m in targets:
        fr = SurroundingRectangle(m, buff=buff)
        fr.set_fill(opacity=0)
        fr.set_stroke(color, width, 1)
        frames.append(fr)
    grp = VGroup(*frames)
    scene.add(grp)
    if rt and rt > 0:
        scene.play(ShowCreation(grp), run_time=rt)
    return frames

def del_hl_objs(scene, frames, rt=0.3):
    stack = [frames]
    flat, seen = [], set()
    while stack:
        cur = stack.pop()
        if cur is None:
            continue
        if isinstance(cur, (list, tuple)):
            stack.extend(cur)
        elif isinstance(cur, Mobject):
            i = id(cur)
            if i not in seen:
                seen.add(i)
                flat.append(cur)
    if not flat:
        return
    if rt and rt > 0:
        scene.play(*[FadeOut(f) for f in flat], run_time=rt)
    try:
        scene.remove(*flat)
    except Exception:
        pass

def _queue_opacity_anim(mobj, target, anims):
    cur = mobj.get_opacity()
    if abs(cur - target) > 1e-6:
        anims.append(ApplyMethod(mobj.set_opacity, float(target)))

def press(scene, G, i, j, wait=0.0, rt=0.3, include_center=True):
    clear_all_bd(G)
    anims = []
    G["btn"][j][i] = not G["btn"][j][i]
    vis_btn=True
    if "grid_vis_btn" in G and 0<=j<len(G["grid_vis_btn"]) and 0<=i<len(G["grid_vis_btn"][0]):
        vis_btn=G["grid_vis_btn"][j][i]
    set_bd(G, "btn", i, j, True if vis_btn else False)
    if rt == 0:
        if vis_btn: G["btn_sp"][j][i].set_opacity(1.0 if G["btn"][j][i] else 0.0)
    else:
        if vis_btn: _queue_opacity_anim(G["btn_sp"][j][i], 1.0 if G["btn"][j][i] else 0.0, anims)
    w = G["params"]["w"]
    h = G["params"]["h"]
    cells = [(i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1)]
    if include_center:
        cells.insert(0, (i, j))
    for x, y in cells:
        if 0 <= x < w and 0 <= y < h:
            G["lgt"][y][x] = not G["lgt"][y][x]
            vis_lgt=True
            if "grid_vis_lgt" in G and 0<=y<len(G["grid_vis_lgt"]) and 0<=x<len(G["grid_vis_lgt"][0]):
                vis_lgt=G["grid_vis_lgt"][y][x]
            set_bd(G, "lgt", x, y, True if vis_lgt else False)
            if rt == 0:
                if vis_lgt: G["lgt_sp"][y][x].set_opacity(1.0 if G["lgt"][y][x] else 0.0)
            else:
                if vis_lgt: _queue_opacity_anim(G["lgt_sp"][y][x], 1.0 if G["lgt"][y][x] else 0.0, anims)
    if rt != 0 and anims:
        scene.play(*anims, run_time=rt)
    if wait > 0:
        scene.wait(wait)

def press_rev(scene, G, i, j, wait=0.0, rt=0.3, include_center=True):
    clear_all_bd(G)
    anims=[]
    G["lgt"][j][i]=not G["lgt"][j][i]
    vis_lgt=True
    if "grid_vis_lgt" in G and 0<=j<len(G["grid_vis_lgt"]) and 0<=i<len(G["grid_vis_lgt"][0]):
        vis_lgt=G["grid_vis_lgt"][j][i]
    set_bd(G,"lgt",i,j,True if vis_lgt else False)
    if rt==0:
        if vis_lgt: G["lgt_sp"][j][i].set_opacity(1.0 if G["lgt"][j][i] else 0.0)
    else:
        if vis_lgt: _queue_opacity_anim(G["lgt_sp"][j][i],1.0 if G["lgt"][j][i] else 0.0,anims)
    w=G["params"]["w"]
    h=G["params"]["h"]
    cells=[(i-1,j),(i+1,j),(i,j-1),(i,j+1)]
    if include_center:
        cells.insert(0,(i,j))
    for x,y in cells:
        if 0<=x<w and 0<=y<h:
            G["btn"][y][x]=not G["btn"][y][x]
            vis_btn=True
            if "grid_vis_btn" in G and 0<=y<len(G["grid_vis_btn"]) and 0<=x<len(G["grid_vis_btn"][0]):
                vis_btn=G["grid_vis_btn"][y][x]
            set_bd(G,"btn",x,y,True if vis_btn else False)
            if rt==0:
                if vis_btn: G["btn_sp"][y][x].set_opacity(1.0 if G["btn"][y][x] else 0.0)
            else:
                if vis_btn: _queue_opacity_anim(G["btn_sp"][y][x],1.0 if G["btn"][y][x] else 0.0,anims)
    if rt!=0 and anims:
        scene.play(*anims,run_time=rt)
    if wait>0:
        scene.wait(wait)

def press_lgt(obj, x, y, scene=None, rt=0.0, only_center=False, bd=True):
    if isinstance(obj, dict):
        G = obj
        lgt = G["lgt"]
        H = len(lgt)
        W = len(lgt[0])
        cells = [(x, y)] if only_center else [(x, y), (x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]
        anims = []
        for (xx, yy) in cells:
            if 0 <= xx < W and 0 <= yy < H:
                lgt[yy][xx] = 0 if lgt[yy][xx] else 1
                vis = True
                if "grid_vis_lgt" in G and 0 <= yy < len(G["grid_vis_lgt"]) and 0 <= xx < len(G["grid_vis_lgt"][0]):
                    vis = G["grid_vis_lgt"][yy][xx]
                if bd: set_bd(G, "lgt", xx, yy, True if vis else False)
                if vis:
                    if rt == 0 or scene is None:
                        G["lgt_sp"][yy][xx].set_opacity(1.0 if lgt[yy][xx] else 0.0)
                    else:
                        _queue_opacity_anim(G["lgt_sp"][yy][xx], 1.0 if lgt[yy][xx] else 0.0, anims)
        if scene is not None and rt != 0 and anims:
            scene.play(*anims, run_time=rt)
        return
    lgt = obj
    H = len(lgt)
    W = len(lgt[0])
    for (xx, yy) in ([(x, y)] if only_center else [(x, y), (x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]):
        if 0 <= xx < W and 0 <= yy < H:
            lgt[yy][xx] ^= 1

def apply_mat(scene, G, MAT, wait=0.0, rt=0.3, clear_end=True, x0=0, y0=0):
    h = len(MAT)
    w = len(MAT[0]) if h > 0 else 0
    for j in range(h):
        for i in range(w):
            if MAT[j][i] == 1:
                press(scene, G, i + x0, j + y0, wait=0.0, rt=rt)
    if clear_end:
        clear_all_bd(G)
    if wait > 0:
        scene.wait(wait)

def set_grid_mats(scene, grids, mat=None, mat_l=None, rt=0.3, clear_first=True, keep_border=True, reset_state=True):
    if isinstance(grids, dict):
        gs = [[grids]]
    elif isinstance(grids, (list, tuple)):
        gs = grids if isinstance(grids[0], (list, tuple)) else [grids]
    else:
        gs = [[grids]]
    def _norm_mats(m):
        if m is None:
            return None
        if isinstance(m[0][0], (list, tuple)):
            return m
        out = []
        for row in gs:
            out.append([m for _ in row])
        return out
    mats_btn = _norm_mats(mat)
    mats_lgt = _norm_mats(mat_l)
    if clear_first:
        del_grids(scene, gs, kp_bd=keep_border, reset_state=reset_state)
    anims = []
    for y in range(len(gs)):
        for x in range(len(gs[y])):
            G = gs[y][x]
            p = G["params"]
            h_b, w_b = p["h"], p["w"]
            h_l, w_l = p.get("h_l", h_b), p.get("w_l", w_b)
            btn_mat = mats_btn[y][x] if mats_btn is not None else None
            lgt_mat = mats_lgt[y][x] if mats_lgt is not None else None
            if lgt_mat is not None:
                lh = len(lgt_mat)
                lw = len(lgt_mat[0]) if lh > 0 else 0
                H2 = min(h_l, lh)
                W2 = min(w_l, lw)
                for j in range(h_l):
                    for i in range(w_l):
                        new_v = G["lgt"][j][i]
                        if j < H2 and i < W2:
                            raw = lgt_mat[j][i]
                            try:
                                v = int(raw)
                            except Exception:
                                v = 1 if raw else 0
                            if v <= -1:
                                pass
                            else:
                                new_v = bool(v)
                        if new_v != G["lgt"][j][i]:
                            G["lgt"][j][i] = new_v
                            vis = True
                            if "grid_vis_lgt" in G and 0 <= j < len(G["grid_vis_lgt"]) and 0 <= i < len(G["grid_vis_lgt"][0]):
                                vis = G["grid_vis_lgt"][j][i]
                            target = 1.0 if (new_v and vis) else 0.0
                            _queue_opacity_anim(G["lgt_sp"][j][i], target, anims)
            if btn_mat is not None:
                mh = len(btn_mat)
                mw = len(btn_mat[0]) if mh > 0 else 0
                H = min(h_b, mh)
                W = min(w_b, mw)
                for j in range(h_b):
                    for i in range(w_b):
                        new_v = G["btn"][j][i]
                        if j < H and i < W:
                            raw = btn_mat[j][i]
                            try:
                                v = int(raw)
                            except Exception:
                                v = 1 if raw else 0
                            if v <= -1:
                                pass
                            else:
                                new_v = bool(v)
                        if new_v != G["btn"][j][i]:
                            G["btn"][j][i] = new_v
                            vis = True
                            if "grid_vis_btn" in G and 0 <= j < len(G["grid_vis_btn"]) and 0 <= i < len(G["grid_vis_btn"][0]):
                                vis = G["grid_vis_btn"][j][i]
                            target = 1.0 if (new_v and vis) else 0.0
                            _queue_opacity_anim(G["btn_sp"][j][i], target, anims)
    if anims:
        scene.play(*anims, run_time=rt)

def del_grids(scene, grids, rt=0.3, kp_bd=False, reset_state=True):
    def _flatten(x):
        out, st = [], [x]
        while st:
            it = st.pop()
            if it is None:
                continue
            if isinstance(it, dict) and "groups" in it:
                out.append(it)
            elif isinstance(it, (list, tuple)):
                st.extend(it)
        return out
    def _present_set():
        s = set()
        for top in scene.mobjects:
            for m in top.get_family():
                s.add(m)
        return s
    gs = _flatten(grids)
    if not gs:
        return
    pres = _present_set()
    if kp_bd:
        fades = []
        for G in gs:
            p = G["params"]
            h_b, w_b = p["h"], p["w"]
            h_l, w_l = p.get("h_l", h_b), p.get("w_l", w_b)
            for j in range(h_l):
                for i in range(w_l):
                    G["lgt_bd_hl"][j][i].set_stroke(opacity=0)
            for j in range(h_b):
                for i in range(w_b):
                    G["btn_bd_hl"][j][i].set_stroke(opacity=0)
            for k in ("lgt_sp", "btn_sp"):
                m = G["groups"][k]
                if m in pres:
                    fades.append(ApplyMethod(m.set_opacity, 0.0))
        if rt > 0 and fades:
            scene.play(*fades, run_time=rt)
        if reset_state:
            for G in gs:
                p = G["params"]
                h_b, w_b = p["h"], p["w"]
                h_l, w_l = p.get("h_l", h_b), p.get("w_l", w_b)
                for j in range(h_l):
                    for i in range(w_l):
                        G["lgt"][j][i] = False
                        G["lgt_sel"][j][i] = False
                for j in range(h_b):
                    for i in range(w_b):
                        G["btn"][j][i] = False
                        G["btn_sel"][j][i] = False
        return
    targets = []
    for G in gs:
        gr = G["groups"]
        cands = [gr["lgt_sp"], gr["btn_sp"], gr["lgt_bd_hl"], gr["lgt_bd_base"], gr["btn_bd_hl"], gr["btn_bd_base"]]
        cands += G.get("extras", {}).get("outer_frames", [])
        for c in cands:
            if c is None:
                continue
            for m in c.get_family():
                if m in pres:
                    targets.append(m)
    if not targets:
        return
    kill = VGroup(*dict.fromkeys(targets))
    if rt > 0:
        scene.play(FadeOut(kill, run_time=rt))
    try:
        scene.remove(kill)
    except Exception:
        pass
    if reset_state:
        for G in gs:
            p = G["params"]
            h_b, w_b = p["h"], p["w"]
            h_l, w_l = p.get("h_l", h_b), p.get("w_l", w_b)
            for j in range(h_l):
                for i in range(w_l):
                    G["lgt"][j][i] = False
                    G["lgt_sel"][j][i] = False
            for j in range(h_b):
                for i in range(w_b):
                    G["btn"][j][i] = False
                    G["btn_sel"][j][i] = False
            G["groups"]["lgt_bd_base"].set_stroke(opacity=0)
            G["groups"]["btn_bd_base"].set_stroke(opacity=0)

def del_labels(scene, *labels, rt=0.3):
    grp = VGroup(*labels)
    scene.play(FadeOut(grp, run_time=rt*RT_LABEL))
    try:
        scene.remove(grp)
    except Exception:
        pass

def _iter_grids(grids):
    if isinstance(grids, dict):
        yield grids
    elif isinstance(grids, (list, tuple)):
        for g in grids:
            yield from _iter_grids(g)

def set_all_lights(scene, grids, on=True, rt=0.3, clear_highlight=True):
    anims = []
    for G in _iter_grids(grids):
        if clear_highlight:
            clear_all_bd(G)
        h = G["params"]["h"]
        w = G["params"]["w"]
        for j in range(h):
            for i in range(w):
                if on:
                    if not G["lgt"][j][i]:
                        G["lgt"][j][i] = True
                        _queue_opacity_anim(G["lgt_sp"][j][i], 1.0, anims)
                else:
                    if G["lgt"][j][i]:
                        G["lgt"][j][i] = False
                        _queue_opacity_anim(G["lgt_sp"][j][i], 0.0, anims)
    if anims:
        scene.play(*anims, run_time=rt)

def mul_vec_mat_begin(scene, mat, vec, res=None, mat_color=I_COLOR, vec_color=Y_COLOR, res_color=X_COLOR, w=None, h=None, mat_label=None, vec_label=None, res_label=None, sz=SZ_DEFAULT, rt=0.3):
    if h is None: h = len(vec)
    if w is None: w = len(vec) if h>0 else 0
    grid_M = make_grid(scene, w, h, mat_l=mat, btn_c=mat_color, lgt_c=mat_color, sz=sz, rt=rt)
    mat_label_obj = None
    if mat_label is not None:
        if isinstance(mat_label, (list, tuple)):
            labels = mat_label
        else:
            labels = [""] * w
            labels[w // 2] = mat_label
        mat_label_obj = add_top_labels(scene, grid_M, labels, dy=sz, color=mat_color, rt=rt)
    left_obj = add_left_labels(scene, grid_M, list(range(h)), dx=sz, rt=rt)
    ctx = {
        "mat":mat,
        "vec":vec,
        "res":res,
        "mat_color":mat_color,
        "vec_color":vec_color,
        "res_color":res_color,
        "sz":sz,
        "rt":rt,
        "h":h,
        "w":w,
        "grid_M":grid_M,
        "left_obj":left_obj,
        "mat_label":mat_label,
        "vec_label":vec_label,
        "res_label":res_label,
        "mat_label_obj":mat_label_obj,
    }
    return ctx

def mul_vec_mat_accumulate(scene, ctx):
    h = ctx["h"]
    w = ctx["w"]
    mat = ctx["mat"]
    vec = ctx["vec"]
    sz = ctx["sz"]
    rt = ctx["rt"]
    vec_color = ctx["vec_color"]
    grid_vec = make_grid(scene, 1, h, mat_l=[[v] for v in vec], btn_x=-(w+3)/2*sz, lgt_x=-(w+3)/2*sz, btn_c=vec_color, lgt_c=vec_color, sz=sz, rt=rt)
    vec_label_obj = None
    if ctx.get("vec_label") is not None:
        labels = ctx["vec_label"] if isinstance(ctx["vec_label"], (list, tuple)) else [ctx["vec_label"]]
        vec_label_obj = add_top_labels(scene, grid_vec, labels, dy=sz, color=vec_color, rt=rt)
    vh_grids = []
    bd_list = []
    for i in range(h):
        if not vec[i]:
            continue
        y = sz * ((h - 1) / 2 - i)
        g = make_grid(scene, w, 1, mat_l=[mat[i]], btn_y=y, lgt_y=y, btn_c=vec_color, lgt_c=vec_color, sz=sz, rt=rt)
        vh_grids.append(g)
    ctx["grid_vec"] = grid_vec
    ctx["vh_grids"] = vh_grids
    ctx["bd_list"] = bd_list
    ctx["vec_label_obj"] = vec_label_obj
    res_color = ctx["res_color"]
    res = ctx.get("res")
    if res is None:
        res_mat_l = [[0] * w]
    else:
        res_mat_l = res
        if res_mat_l and not isinstance(res_mat_l[0], (list, tuple)):
            res_mat_l = [list(res_mat_l)]
    grid_res = make_grid(scene, w, 1, mat_l=res_mat_l, btn_y=-(h+3)/2*sz, lgt_y=-(h+3)/2*sz, btn_c=res_color, lgt_c=res_color, sz=sz, rt=rt)
    res_label_obj = None
    if ctx.get("res_label") is not None:
        labels = ctx["res_label"] if isinstance(ctx["res_label"], (list, tuple)) else [ctx["res_label"]]
        res_label_obj = add_left_labels(scene, grid_res, labels, dx=sz, color=res_color, rt=rt)
    ctx["grid_res"] = grid_res
    ctx["res_label_obj"] = res_label_obj
    for i in range(len(vh_grids)):
        add_grid(scene, vh_grids[i], grid_res, keep_from=False, rt=rt)
    return grid_res

def mul_vec_mat_cleanup(scene, ctx, clear_res=True):
    grids = [ctx["grid_M"], ctx["grid_vec"]] + ctx["vh_grids"]
    rt = ctx["rt"]
    if clear_res:
        grids.append(ctx["grid_res"])
    del_left_labels(scene, ctx["left_obj"], rt=rt)
    if ctx.get("mat_label_obj"):
        del_top_labels(scene, ctx["mat_label_obj"], rt=rt)
    if ctx.get("vec_label_obj"):
        del_top_labels(scene, ctx["vec_label_obj"], rt=rt)
    if ctx.get("res_label_obj"):
        del_left_labels(scene, ctx["res_label_obj"], rt=rt)
    del_grids(scene, grids, rt=rt)

def mul_vec_mat(scene, mat, vec, mat_color=I_COLOR, vec_color=Y_COLOR, res_color=X_COLOR, w=None, h=None, mat_label=None, vec_label=None, res_label=None, wait=1.0, sz=SZ_DEFAULT, rt=0.3):
    ctx = mul_vec_mat_begin(scene, mat, vec, None, mat_color, vec_color, res_color, w=w, h=h, mat_label=mat_label, vec_label=vec_label, res_label=res_label, sz=sz, rt=rt)
    mul_vec_mat_accumulate(scene, ctx)
    scene.wait(wait)
    mul_vec_mat_cleanup(scene, ctx)
    return ctx

def _split_inline_math(s):
    parts = []
    buf = ""
    m = False
    esc = False
    for ch in s:
        if esc:
            if ch == "$":
                buf += "$"
            else:
                buf += "\\" + ch
            esc = False
            continue
        if ch == "\\":
            esc = True
            continue
        if ch == "$":
            if m:
                parts.append(("tex", buf))
                buf = ""
                m = False
            else:
                if buf:
                    parts.append(("text", buf))
                buf = ""
                m = True
        else:
            buf += ch
    if buf:
        parts.append(("tex" if m else "text", buf))
    return parts

def _parse_color_segments(line, color_map, default_color):
    if not color_map:
        return [(line, default_color)]
    segs = []
    buf = ""
    cur_color = default_color
    i = 0
    n = len(line)
    changed = False
    while i < n:
        ch = line[i]
        if ch == "<":
            j = line.find(">", i + 1)
            if j != -1:
                tag = line[i + 1:j].strip()
                if tag in color_map:
                    if buf:
                        segs.append((buf, cur_color))
                        buf = ""
                    cur_color = color_map[tag]
                    changed = True
                    i = j + 1
                    continue
            buf += ch
            i += 1
        else:
            buf += ch
            i += 1
    if buf:
        segs.append((buf, cur_color))
    if not changed:
        return [(line, default_color)]
    return segs

def normalize_by_ref(objs, factor, ref_tex=REF_TEX, scene=None, text_desc=None):
    try:
        ref = Tex(ref_tex)
        ref.scale(1)
        h_ref = float(ref.get_height())
    except Exception:
        h_ref = 0.0
    if h_ref <= 1e-6:
        return
    target = h_ref * factor
    for o in objs:
        try:
            h = float(o.get_height())
        except Exception:
            h = 0.0
        if h > 1e-6:
            before = h
            s = target / h
            if abs(s - 1.0) > 1e-3:
                o.scale(s)
                try:
                    after = float(o.get_height())
                except Exception:
                    after = before * s
            else:
                after = before
            try:
                ts = _fmt_scene_time_ms(scene) if scene is not None else "00:00:00.000"
                txt = "" if text_desc is None else str(text_desc).replace("\n", " ")
                with open("normal.txt", "a", encoding="utf-8") as f:
                    f.write(f"{ts} {before:.6f} {after:.6f} {txt}\n")
            except Exception:
                pass

def _mk_line_group_color(line, font, size, default_color, baseline, auto_k, ref_tex, color_map):
    segs = _parse_color_segments(line, color_map, default_color)
    if len(segs) == 1 and segs[0][1] == default_color and "<" not in line:
        return _mk_line_group(line, font, size, default_color, baseline, auto_k, ref_tex)
    if "$" not in line:
        scale = size / FONT_SIZE_DEFAULT
        text = "".join(t for t, c in segs)
        m = Text(text, font=font)
        m.scale(scale)
        m.set_color(default_color)
        char_count = len(text)
        glyph_count = len(m)
        if glyph_count == char_count:
            idx = 0
            for t, c in segs:
                if not t:
                    continue
                if c != default_color:
                    for k in range(len(t)):
                        m[idx + k].set_color(c)
                idx += len(t)
        else:
            for t, c in segs:
                if c != default_color and t:
                    m.set_color_by_text(t, c)
        return m
    parts = []
    for txt, col in segs:
        if not txt:
            continue
        g = _mk_line_group(txt, font, size, col, baseline, auto_k, ref_tex)
        parts.append(g)
    if not parts:
        return _mk_line_group("", font, size, default_color, baseline, auto_k, ref_tex)
    return VGroup(*parts).arrange(RIGHT, buff=0.0, aligned_edge=DOWN)

def _mk_line_group(s, font, size, color, baseline=0.0, auto_k=0.5, ref_tex=REF_TEX):
    segs = _split_inline_math(s)
    scale = size / FONT_SIZE_DEFAULT
    if not segs:
        m = Text("", font=font)
        m.set_color(color)
        m.scale(scale)
        return m
    objs, tags = [], []
    for k, v in segs:
        if k == "tex":
            m = Tex(v)
            m.set_color(color)
            m.scale(scale)
            objs.append(m)
            tags.append("tex")
        else:
            m = Text(v, font=font)
            m.set_color(color)
            m.scale(scale)
            objs.append(m)
            tags.append("text")
    grp = VGroup(*objs).arrange(RIGHT, buff=0.15, aligned_edge=DOWN)
    text_bottoms = [o.get_bottom()[1] for o, t in zip(objs, tags) if t == "text"]
    if text_bottoms:
        ref = min(text_bottoms)
        h_ref = Tex(ref_tex).scale(scale).get_height() if auto_k else 0.0
        for o, t in zip(objs, tags):
            if t == "tex":
                dy = (ref - o.get_bottom()[1]) + baseline * scale
                if auto_k:
                    dy -= auto_k * (o.get_height() - h_ref)
                if abs(dy) > 1e-6:
                    o.shift(UP * dy)
    return grp

def _fmt_scene_time_ms(scene):
    t = 0.0
    try:
        if hasattr(scene, "time"):
            t = float(scene.time)
        elif hasattr(scene, "renderer") and hasattr(scene.renderer, "time"):
            t = float(scene.renderer.time)
        elif hasattr(scene, "renderer") and hasattr(scene.renderer, "get_time"):
            t = float(scene.renderer.get_time())
    except Exception:
        t = 0.0
    ms = int(round(t * 1000))
    s = ms // 1000
    ms = ms % 1000
    h = s // 3600
    m = (s % 3600) // 60
    s = s % 60
    return f"{h:02d}:{m:02d}:{s:02d}.{ms:03d}"

def show_subtitle(scene, text, text2=None, run_in=0.3, run_out=0.3, font=FONT_DEFAULT, font_size=FONT_SIZE_DEFAULT, line_gap=0.2, buff=0.5, baseline=0.05, auto_k=0.5, ref_tex=REF_TEX):
    old=getattr(scene,"_subtitle_mobj", getattr(scene,"_subtitle_", None))
    if old is not None:
        scene.play(FadeOut(old, run_time=run_out))
        try:
            scene.remove(old)
        except Exception:
            pass
        scene._subtitle_mobj = None
    parts = []
    if isinstance(text, (list, tuple)):
        parts = [str(x) for x in text]
    else:
        if text is not None:
            parts.append(str(text))
        if text2 is not None:
            parts.append(str(text2))
    parts = [p for p in parts if p is not None]
    if len(parts) == 0 or all(p == "" for p in parts):
        return None
    out_text = "".join(parts)
    try:
        ts = _fmt_scene_time_ms(scene)
        with open("subtitle.txt", "a", encoding="utf-8") as f:
            f.write(f"{ts} {out_text}\n")
        with open("subtitle_raw.txt", "a", encoding="utf-8") as f:
            f.write(f"{out_text}\n")
    except Exception:
        pass
    wrapped_parts = [f"{ADD_TEX}{p}{ADD_TEX}" for p in parts]
    lines = VGroup(*[_mk_line_group_color(p, font, font_size, WHITE, baseline, auto_k, ref_tex, COLOR_MAP) for p in wrapped_parts])
    normalize_by_ref(lines.submobjects, SCALE_SUBTITLE * font_size / FONT_SIZE_DEFAULT, ref_tex, scene=scene, text_desc=out_text)
    lines.arrange(DOWN, buff=line_gap).to_edge(DOWN, buff=buff)
    scene.add(lines)
    scene.play(FadeIn(lines, run_time=run_in))
    scene._subtitle_mobj = lines
    scene._subtitle_ = lines
    return lines

def show_title(scene, line1=None, line2=None, run_in=0.3, run_out=0.3, font=FONT_DEFAULT, size1=FONT_SIZE_LARGE, size2=FONT_SIZE_DEFAULT, line_gap=0.15, buff=0.5, pause=0.8, rt=0.3, ref_tex=REF_TEX):
    show_subtitle(scene, "")
    old = getattr(scene, "_title_mobj", None)
    if old is not None:
        scene.play(FadeOut(old, run_time=run_out))
        try:
            scene.remove(old)
        except Exception:
            pass
        scene._title_mobj = None
    parts = []
    if isinstance(line1, (list, tuple)):
        parts = [str(x) for x in line1][:2]
    else:
        if line1 is not None:
            parts.append(str(line1))
        if line2 is not None:
            parts.append(str(line2))
    parts = [p for p in parts if p is not None]
    if len(parts) == 0 or all(p == "" for p in parts):
        return None
    out_text = "".join(parts)
    try:
        with open("title.txt", "a", encoding="utf-8") as f:
            f.write(f"{_fmt_scene_time_ms(scene)} {out_text}\n")
    except Exception:
        pass
    objs = []
    if len(parts) >= 1 and parts[0] != "":
        t1 = _mk_line_group(parts[0], font, size1, WHITE)
        normalize_by_ref([t1], SCALE_TITLE * size1 / FONT_SIZE_LARGE, ref_tex, scene=scene, text_desc=parts[0])
        objs.append(t1)
    if len(parts) >= 2 and parts[1] != "":
        t2 = _mk_line_group(parts[1], font, size2, WHITE)
        normalize_by_ref([t2], SCALE_TITLE * size2 / FONT_SIZE_DEFAULT, ref_tex, scene=scene, text_desc=parts[1])
        objs.append(t2)
    if not objs:
        return None
    grp = VGroup(*objs).arrange(DOWN, buff=line_gap)
    grp.move_to(ORIGIN)
    scene.add(grp)
    scene.play(FadeIn(grp, run_time=run_in))
    scene.wait(pause)
    scene.play(ApplyMethod(grp.to_edge, UP, buff), run_time=rt)
    scene._title_mobj = grp
    return grp

def show_latex(scene, text, x=0.0, y=0.0, run_in=0.3, run_out=0.3, font=FONT_LATEX, font_size=32, buff=0.5, line_gap=0.1, baseline=0.0, auto_k=0.5, ref_tex=REF_TEX, show=True, color_map=COLOR_MAP, default_color=WHITE, add_tex=ADD_TEX):
    parts = []
    if isinstance(text, (list, tuple)):
        parts = [str(p) for p in text if p is not None]
    else:
        if text is None:
            return None
        s = str(text)
        if "<br" in s:
            s = s.replace("<br/>", "<br>").replace("<br />", "<br>")
            s = s.replace("\n", "<br>")
            parts = s.split("<br>")
        else:
            parts = s.split("\n")
    parts = [p for p in parts if p is not None]
    if len(parts) == 0 or all(p == "" for p in parts):
        return None
    if isinstance(text, (list, tuple)):
        text_desc = "".join(str(p) for p in text if p is not None)
    else:
        text_desc = "" if text is None else str(text)
    wrapped_parts = []
    for p in parts:
        wrapped_parts.append(f"{add_tex}{p}{add_tex}")
    parts = wrapped_parts
    lines = VGroup(*[_mk_line_group_color(p, font, font_size, default_color, baseline, auto_k, ref_tex, color_map) for p in parts])
    h0 = 0.0
    for line in lines.submobjects:
        try:
            h_line = float(line.get_height())
        except Exception:
            h_line = 0.0
        if h_line > h0:
            h0 = h_line
    normalize_by_ref(lines.submobjects, SCALE_LATEX * font_size / 32, ref_tex, scene=scene, text_desc=text_desc)
    h1 = 0.0
    for line in lines.submobjects:
        try:
            h_line = float(line.get_height())
        except Exception:
            h_line = 0.0
        if h_line > h1:
            h1 = h_line
    lines.arrange(DOWN, buff=line_gap, aligned_edge=LEFT)
    lines.move_to(ORIGIN)
    lines.shift(RIGHT * x + UP * y)
    try:
        if isinstance(text, (list, tuple)):
            raw_text = "".join(str(p) for p in text if p is not None)
        else:
            raw_text = "" if text is None else str(text)
        raw_text = raw_text.replace("<br/>", "")
        raw_text = raw_text.replace("<br />", "")
        raw_text = raw_text.replace("<br>", "")
        s = raw_text
        res = []
        i = 0
        n = len(s)
        while i < n:
            ch = s[i]
            if ch == "<" and i + 2 < n and s[i + 1] == "c":
                j = i + 2
                while j < n and s[j] != ">":
                    j += 1
                if j < n:
                    i = j + 1
                    continue
            res.append(ch)
            i += 1
        raw_clean = "".join(res)
        if raw_clean.strip():
            with open("latex.txt", "a", encoding="utf-8") as f:
                f.write(f"{_fmt_scene_time_ms(scene)} {h0:.6f} {h1:.6f} {raw_clean}\n")
    except Exception:
        pass
    if not show or scene is None:
        return lines
    scene.add(lines)
    if run_in > 0:
        scene.play(FadeIn(lines, run_time=run_in))
    scene._latex_mobj = lines
    stack = getattr(scene, "_latex_stack", None)
    if stack is None:
        stack = []
        setattr(scene, "_latex_stack", stack)
    stack.append(lines)
    return lines

def trans_latex(scene, latex_from, latex_to, rt=0.8):
    if latex_from is None or latex_to is None:
        return None
    scene.play(ReplacementTransform(latex_from, latex_to), run_time=rt)
    stack = getattr(scene, "_latex_stack", None)
    if stack is None:
        stack = []
        setattr(scene, "_latex_stack", stack)
    if latex_from in stack:
        stack.remove(latex_from)
    if latex_to not in stack:
        stack.append(latex_to)
    if getattr(scene, "_latex_mobj", None) is latex_from:
        scene._latex_mobj = latex_to
    return latex_to

def del_latex(scene, *objs, rt=0.3):
    if not objs:
        m = getattr(scene, "_latex_mobj", None)
        if m is None:
            return
        objs = (m,)
    flat, seen = [], set()
    for o in objs:
        if o is None:
            continue
        if isinstance(o, (list, tuple)):
            for t in o:
                if t is None:
                    continue
                if id(t) in seen:
                    continue
                flat.append(t)
                seen.add(id(t))
        else:
            if id(o) in seen:
                continue
            flat.append(o)
            seen.add(id(o))
    stack = getattr(scene, "_latex_stack", [])
    for m in flat:
        if rt > 0:
            scene.play(FadeOut(m, run_time=rt))
        try:
            scene.remove(m)
        except Exception:
            pass
        if m in stack:
            stack.remove(m)
        if getattr(scene, "_latex_mobj", None) is m:
            setattr(scene, "_latex_mobj", stack[-1] if stack else None)

def add_grid_labels(scene, G, labels2d, font=FONT_DEFAULT, scale=SCALE_SMALLER, rt=0.3, ref_tex=REF_TEX, **kwargs):
    def _pick_cells_for_labels2d():
        lgt = G.get("lgt_bd_base")
        btn = G.get("btn_bd_base")
        cands = [c for c in (lgt, btn) if c]
        if not cands:
            return None
        H_lab = len(labels2d) if labels2d is not None else 0
        W_lab = max((len(r or []) for r in (labels2d or [])), default=0)
        best, best_score = None, None
        for c in cands:
            H, W = len(c), (len(c[0]) if c and c[0] else 0)
            if H_lab > H or W_lab > W:
                score = (abs(H - H_lab) + abs(W - W_lab) + 1000000)
            else:
                score = abs(H - H_lab) + abs(W - W_lab)
            if best_score is None or score < best_score:
                best, best_score = c, score
        return best
    cells = _pick_cells_for_labels2d()
    if not cells:
        return []
    H, W = len(cells), len(cells[0])
    sz = G["params"]["sz"]
    R = min(H, len(labels2d))
    objs2d = [[None for _ in range(W)] for _ in range(H)]
    created = []
    for r in range(R):
        row_labels = labels2d[r] or []
        C = min(W, len(row_labels))
        for c in range(C):
            s = row_labels[c]
            if s is None or s == "":
                continue
            m = Text(str(s), font=font).scale(scale*sz/SZ_DEFAULT)
            m.move_to(cells[r][c].get_center())
            objs2d[r][c] = m
            created.append(m)
    if created:
        scene.add(*created)
        if rt and rt > 0:
            scene.play(*[FadeIn(o) for o in created], run_time=rt)
    return objs2d

def add_top_labels(scene, G, labels, font=FONT_DEFAULT, scale=SCALE_DEFAULT, dy=None, rt=0.3, ref_tex=REF_TEX, color=WHITE, **kwargs):
    def _pick_cells_for_cols(n_cols):
        lgt = G.get("lgt_bd_base")
        btn = G.get("btn_bd_base")
        cands = [c for c in (lgt, btn) if c]
        if not cands:
            return None
        best, best_score = None, None
        for c in cands:
            W = len(c[0]) if c and c[0] else 0
            score = abs(W - n_cols)
            if best_score is None or score < best_score:
                best, best_score = c, score
        return best
    cells = _pick_cells_for_cols(len(labels))
    if not cells:
        return []
    W = len(cells[0])
    sz = G["params"]["sz"]
    shift = dy if dy is not None else sz
    n = min(W, len(labels))
    objs = []
    desc = []
    for i in range(n):
        s = labels[i]
        if s is None or s == "":
            continue
        m = Text(str(s), font=font)
        m.set_color(color)
        pos = cells[0][i].get_center() + UP * shift
        m.move_to(pos)
        objs.append(m)
        desc.append(str(s))
    text_desc = " ".join(desc)
    normalize_by_ref(objs, scale*sz/SZ_DEFAULT, ref_tex, scene=scene, text_desc=text_desc)
    if objs:
        scene.add(*objs)
        if rt and rt > 0:
            scene.play(*[FadeIn(o) for o in objs], run_time=rt*RT_LABEL)
    return objs

def add_left_labels(scene, G, labels, font=FONT_DEFAULT, scale=SCALE_DEFAULT, dx=None, rt=0.3, ref_tex=REF_TEX, color=WHITE, **kwargs):
    def _pick_cells_for_rows(n_rows):
        lgt = G.get("lgt_bd_base")
        btn = G.get("btn_bd_base")
        cands = [c for c in (lgt, btn) if c]
        if not cands:
            return None
        best, best_score = None, None
        for c in cands:
            H = len(c)
            score = abs(H - n_rows)
            if best_score is None or score < best_score:
                best, best_score = c, score
        return best
    cells = _pick_cells_for_rows(len(labels))
    if not cells:
        return []
    H = len(cells)
    sz = G["params"]["sz"]
    shift = dx if dx is not None else sz
    n = min(H, len(labels))
    objs = []
    desc = []
    for j in range(n):
        s = labels[j]
        if s is None or s == "":
            continue
        m = Text(str(s), font=font)
        m.set_color(color)
        pos = cells[j][0].get_center() + LEFT * shift
        m.move_to(pos)
        objs.append(m)
        desc.append(str(s))
    text_desc = " ".join(desc)
    normalize_by_ref(objs, scale*sz/SZ_DEFAULT, ref_tex, scene=scene, text_desc=text_desc)
    if objs:
        scene.add(*objs)
        if rt and rt > 0:
            scene.play(*[FadeIn(o) for o in objs], run_time=rt*RT_LABEL)
    return objs

def add_bottom_label(scene, G, label, font=FONT_DEFAULT, scale=SCALE_DEFAULT, dy=None, rt=0.3, ref_tex=REF_TEX, color=WHITE, **kwargs):
    lgt = G.get("lgt_bd_base")
    btn = G.get("btn_bd_base")
    cells = lgt if lgt else btn
    if not cells:
        return []
    sz = G["params"]["sz"]
    shift = dy if dy is not None else sz
    row = VGroup(*cells[-1])
    s = str(label)
    m = Text(s, font=font)
    m.set_color(color)
    pos = row.get_center() + DOWN * shift
    m.move_to(pos)
    objs = [m]
    normalize_by_ref(objs, scale*sz/SZ_DEFAULT, ref_tex, scene=scene, text_desc=s)
    scene.add(*objs)
    if rt and rt > 0:
        scene.play(*[FadeIn(o) for o in objs], run_time=rt*RT_LABEL)
    return objs

def del_grid_labels(scene, objs2d, rt=0.3):
    try:
        del_top_labels(scene, objs2d, rt=rt)
        return
    except NameError:
        pass
    stack, flat, seen = [objs2d], [], set()
    while stack:
        cur = stack.pop()
        if cur is None:
            continue
        if isinstance(cur, (list, tuple)):
            stack.extend(cur)
        elif isinstance(cur, Mobject):
            i = id(cur)
            if i not in seen:
                seen.add(i)
                flat.append(cur)
    if not flat:
        return
    try:
        scene.play(*[FadeOut(o) for o in flat], run_time=rt)
    except Exception:
        pass
    try:
        scene.remove(*flat)
    except Exception:
        pass

def del_top_labels(scene, objs, rt=0.3):
    stack = [objs]
    flat, seen = [], set()
    while stack:
        cur = stack.pop()
        if cur is None:
            continue
        if isinstance(cur, (list, tuple)):
            stack.extend(cur)
        elif isinstance(cur, Mobject):
            i = id(cur)
            if i not in seen:
                seen.add(i)
                flat.append(cur)
    if not flat:
        return
    try:
        scene.play(*[FadeOut(o) for o in flat], run_time=rt*RT_LABEL)
    except Exception:
        pass
    try:
        scene.remove(*flat)
    except Exception:
        pass

def del_left_labels(scene, objs, rt=0.3):
    stack = [objs]
    flat, seen = [], set()
    while stack:
        cur = stack.pop()
        if cur is None:
            continue
        if isinstance(cur, (list, tuple)):
            stack.extend(cur)
        elif isinstance(cur, Mobject):
            i = id(cur)
            if i not in seen:
                seen.add(i)
                flat.append(cur)
    if not flat:
        return
    try:
        scene.play(*[FadeOut(o) for o in flat], run_time=rt*RT_LABEL)
    except Exception:
        pass
    try:
        scene.remove(*flat)
    except Exception:
        pass

def del_bottom_labels(scene, objs, rt=0.3):
    stack = [objs]
    flat, seen = [], set()
    while stack:
        cur = stack.pop()
        if cur is None:
            continue
        if isinstance(cur, (list, tuple)):
            stack.extend(cur)
        elif isinstance(cur, Mobject):
            i = id(cur)
            if i not in seen:
                seen.add(i)
                flat.append(cur)
    if not flat:
        return
    try:
        scene.play(*[FadeOut(o) for o in flat], run_time=rt*RT_LABEL)
    except Exception:
        pass
    try:
        scene.remove(*flat)
    except Exception:
        pass

def show_center_latex(
    scene,
    latex_blocks,
    run_in=0.8,
    line_buff=0.20,
    inner_line_buff=0.10,
    hbuff=0.18,
    group_scale=0.82,
    align_left=True,
    default_indent=1.0,
    font=FONT_DEFAULT,
    shift_x=0.0,
    shift_y=0.0,
    replace_old=True,
    normalize=True,
    ref_tex=REF_TEX
):
    def _sanitize_tex(s: str) -> str:
        s = s.replace(r"\left(", "(").replace(r"\right)", ")")
        s = s.replace(r"\left[", "[").replace(r"\right]", "]")
        s = s.replace(r"\left\{", "{").replace(r"\right\}", "}")
        s = s.replace("\u00A0", " ").replace("\u202F", " ")
        return s
    rows = []
    for blk in latex_blocks:
        btype = blk.get("type", "text")
        s = float(blk.get("scale", 1.0))
        cn_s = float(blk.get("cn_scale", s * 0.77))
        do_norm = bool(blk.get("normalize", normalize))
        rtex = blk.get("ref_tex", ref_tex)
        if btype == "tex":
            m = Tex(_sanitize_tex(blk["content"])).scale(s)
            if do_norm:
                normalize_by_ref([m], s, rtex, scene=scene, text_desc=blk.get("content"))
        elif btype == "tex_lines":
            lines = [Tex(_sanitize_tex(x)).scale(s) for x in blk["content"]]
            if do_norm:
                normalize_by_ref(lines, s, rtex, scene=scene, text_desc="tex_lines")
            m = VGroup(*lines).arrange(DOWN, buff=inner_line_buff, aligned_edge=LEFT)
        elif btype == "tex_cn_lines":
            row_items = []
            for item in blk["content"]:
                t = Tex(_sanitize_tex(item["tex"])).scale(s)
                cn = Text(item.get("cn", ""), font=font).scale(cn_s)
                row_items.append(VGroup(t, cn).arrange(RIGHT, buff=hbuff, aligned_edge=DOWN))
            if do_norm:
                normalize_by_ref(row_items, s, rtex, scene=scene, text_desc="tex_cn_lines")
            m = VGroup(*row_items).arrange(DOWN, buff=inner_line_buff, aligned_edge=LEFT)
        else:
            m = Text(blk["content"], font=font).scale(s)
            if do_norm:
                normalize_by_ref([m], s, rtex, scene=scene, text_desc=blk.get("content"))
        indent = float(blk.get("indent", default_indent))
        if indent != 0:
            pad = Rectangle(width=indent, height=0.001, stroke_width=0, fill_opacity=0)
            m = VGroup(pad, m).arrange(RIGHT, buff=0, aligned_edge=DOWN)
        rows.append(m)
    group = VGroup(*rows).arrange(DOWN, buff=line_buff, aligned_edge=(LEFT if align_left else ORIGIN))
    group.scale(group_scale)
    group.move_to(ORIGIN)
    group.shift(RIGHT * shift_x + UP * shift_y)
    old = getattr(scene, "_center_latex_group", None)
    if replace_old and old is not None:
        try:
            scene.play(FadeOut(old, lag_ratio=0.06, run_time=0.25))
            scene.remove(old)
        except Exception:
            pass
        lst = getattr(scene, "_center_latex_groups", None)
        if isinstance(lst, list):
            try:
                lst.remove(old)
            except Exception:
                pass
    lst = getattr(scene, "_center_latex_groups", None)
    if not isinstance(lst, list):
        lst = []
        setattr(scene, "_center_latex_groups", lst)
    lst.append(group)
    scene._center_latex_group = group
    scene.play(FadeIn(group, lag_ratio=0.08, run_time=run_in))
    return group

def remove_center_latex(scene, group=None, rt=0.8):
    if group is None:
        lst = getattr(scene, "_center_latex_groups", None)
        if isinstance(lst, list) and lst:
            for g in list(lst):
                try:
                    scene.play(FadeOut(g, lag_ratio=0.08, run_time=rt))
                    scene.remove(g)
                except Exception:
                    pass
            lst.clear()
        else:
            g = getattr(scene, "_center_latex_group", None)
            if g is not None:
                try:
                    scene.play(FadeOut(g, lag_ratio=0.08, run_time=rt))
                    scene.remove(g)
                except Exception:
                    pass
        scene._center_latex_group = None
    else:
        try:
            scene.play(FadeOut(group, lag_ratio=0.08, run_time=rt))
            scene.remove(group)
        except Exception:
            pass
        lst = getattr(scene, "_center_latex_groups", None)
        if isinstance(lst, list):
            try:
                lst.remove(group)
            except Exception:
                pass
        if getattr(scene, "_center_latex_group", None) is group:
            scene._center_latex_group = None if not getattr(scene, "_center_latex_groups", None) else (scene._center_latex_groups[-1] if scene._center_latex_groups else None)

def calc_shift_y_for_top(scene, latex_blocks, top_y, line_buff=0.20, inner_line_buff=0.10, hbuff=0.18, group_scale=0.82, align_left=True, default_indent=1.0, font=FONT_DEFAULT, shift_x=0.0, normalize=True, ref_tex=REF_TEX):
    def _sanitize_tex(s: str) -> str:
        s = s.replace(r"\left(", "(").replace(r"\right)", ")")
        s = s.replace(r"\left[", "[").replace(r"\right]", "]")
        s = s.replace(r"\left\{", "{").replace(r"\right\}", "}")
        s = s.replace("\u00A0", " ").replace("\u202F", " ")
        return s
    rows=[]
    for blk in latex_blocks:
        btype=blk.get("type","text")
        s=float(blk.get("scale",1.0))
        cn_s=float(blk.get("cn_scale",s*0.77))
        do_norm=bool(blk.get("normalize",normalize))
        rtex=blk.get("ref_tex",ref_tex)
        if btype=="tex":
            m=Tex(_sanitize_tex(blk["content"])).scale(s)
            if do_norm: normalize_by_ref([m], s, rtex, scene=scene, text_desc=blk.get("content"))
        elif btype=="tex_lines":
            lines=[Tex(_sanitize_tex(x)).scale(s) for x in blk["content"]]
            if do_norm: normalize_by_ref(lines, s, rtex, scene=scene, text_desc="tex_lines")
            m=VGroup(*lines).arrange(DOWN,buff=inner_line_buff,aligned_edge=LEFT)
        elif btype=="tex_cn_lines":
            row_items=[]
            for item in blk["content"]:
                t=Tex(_sanitize_tex(item["tex"])).scale(s)
                cn=Text(item.get("cn",""),font=font).scale(cn_s)
                row_items.append(VGroup(t,cn).arrange(RIGHT,buff=hbuff,aligned_edge=DOWN))
            if do_norm: normalize_by_ref(row_items, s, rtex, scene=scene, text_desc="tex_cn_lines")
            m=VGroup(*row_items).arrange(DOWN,buff=inner_line_buff,aligned_edge=LEFT)
        else:
            m=Text(blk["content"],font=font).scale(s)
            if do_norm: normalize_by_ref([m], s, rtex, scene=scene, text_desc=blk.get("content"))
        indent=float(blk.get("indent",default_indent))
        if indent!=0:
            pad=Rectangle(width=indent,height=0.001,stroke_width=0,fill_opacity=0)
            m=VGroup(pad,m).arrange(RIGHT,buff=0,aligned_edge=DOWN)
        rows.append(m)
    g=VGroup(*rows).arrange(DOWN,buff=line_buff,aligned_edge=(LEFT if align_left else ORIGIN))
    g.scale(group_scale)
    g.move_to(ORIGIN)
    g.shift(RIGHT*shift_x)
    return float(top_y) - float(g.get_top()[1])

def show_algo_table(
    scene,
    x=0.0,
    y=3.0,
    run_in=0.3,
    run_out=0.3,
    font=FONT_LATEX,
    font_size=FONT_SIZE_DEFAULT,
    row_gap=0.4,
    col_gap=0.6,
    baseline=0.0,
    auto_k=0.5,
    ref_tex=REF_TEX,
    show=True,
    color_map=COLOR_MAP,
    default_color=WHITE,
    header_color=WHITE,
):
    headers = ("输出", "输入", "说明", "算法", "公式")
    def make_cell(text, color, tag, is_header=False):
        if isinstance(text, str) and text.strip() == "-":
            text = ""
        if not is_header and isinstance(text, str) and text:
            text = f"{tag}{text}"
        if isinstance(text,str) and text:
            text=text.replace("¬","¬")
        c = header_color if is_header else color
        m = show_latex(
            scene,
            text,
            x=0,
            y=0,
            run_in=0.0,
            run_out=0.0,
            font=font,
            font_size=font_size,
            buff=0.5,
            line_gap=0.0,
            baseline=baseline,
            auto_k=auto_k,
            ref_tex=ref_tex,
            show=False,
            color_map=color_map,
            default_color=c,
            add_tex="",
        )
        if m is None:
            return VGroup()
        if isinstance(m, VGroup) and len(m.submobjects) == 1:
            m = m.submobjects[0]
        m.move_to(ORIGIN)
        return m
    header_row = [make_cell(h, default_color, "", True) for h in headers]
    data_rows = []
    for color, color_tag, out_sym, in_sym, desc, algo, formula in LATEX_MAT:
        row = [
            make_cell(out_sym,   color, color_tag),
            make_cell(in_sym,    color, color_tag),
            make_cell(desc,      color, color_tag),
            make_cell(algo,      color, color_tag),
            make_cell(formula,   color, color_tag),
        ]
        data_rows.append(row)
    all_rows = [header_row] + data_rows
    n_cols = len(headers)
    col_widths = [0.0] * n_cols
    for row in all_rows:
        for j, cell in enumerate(row):
            w = float(cell.get_width())
            if w > col_widths[j]:
                col_widths[j] = w
    table_rows = []
    for row in all_rows:
        for j, cell in enumerate(row):
            x_left = sum(col_widths[:j]) + j * col_gap
            cur_left = float(cell.get_left()[0])
            cell.shift(RIGHT*(x_left-cur_left))
        table_rows.append(VGroup(*row))
    table = VGroup(*table_rows).arrange(DOWN, buff=row_gap, aligned_edge=LEFT)
    table.move_to(ORIGIN).shift(RIGHT*x+UP*y)
    if show:
        scene.add(table)
        scene.play(FadeIn(table, run_time=run_in))
    return table

def hide_algo_table(scene, table=None, run_out=0.3, remove=True):
    if table is None:
        table = getattr(scene, "_algo_table", None)
    if table is None:
        return None
    if run_out > 0:
        scene.play(FadeOut(table, run_time=run_out))
    if remove:
        scene.remove(table)
    if getattr(scene, "_algo_table", None) is table:
        scene._algo_table = None
    return table

def show_algo_time_table(
    scene,
    x=0.0,
    y=0.2,
    run_in=0.3,
    run_out=0.3,
    font=FONT_LATEX,
    font_size=16,
    cell_pad_x=0.12,
    cell_pad_y=0.06,
    col_gap=0.24,
    row_gap=0.12,
    baseline=0.0,
    auto_k=0.5,
    ref_tex=REF_TEX,
    show=True,
    color_map=COLOR_MAP,
    default_color=WHITE,
    header_color=WHITE,
    border_color=WHITE,
    border_width=1.6,
    outer_border_width=2.4,
    text_buff=0.35,
    max_width=13.6,
    max_height=7.4,
):
    headers = ("n", "2ⁿˣⁿ", "2ⁿ", "n⁶", "n³", "n³/ω", "n²", "n²/ω")
    data = [
        ("4",     "42毫秒",   "-",     "-",      "-",      "-",       "-",       "-"),
        ("5",     "42秒",     "-",     "-",      "-",      "-",       "-",       "-"),
        ("6",     "2天",      "-",     "-",      "-",      "-",       "-",       "-"),
        ("7",     "61年",     "-",     "-",      "-",      "-",       "-",       "-"),
        ("8",     "300万年",  "1毫秒",  "-",      "-",      "-",       "-",       "-"),
        ("9",     "-",        "3毫秒",  "-",      "-",      "-",       "-",       "-"),
        ("10",    "-",        "10毫秒", "10毫秒", "-",      "-",       "-",       "-"),
        ("20",    "-",        "84秒",   "640毫秒","-",      "-",       "-",       "-"),
        ("40",    "-",        "22年",   "41秒",   "1毫秒",  "-",       "-",       "-"),
        ("100",   "-",        "-",      "3小时",  "10毫秒", "-",       "-",       "-"),
        ("200",   "-",        "-",      "7天",    "80毫秒", "3毫秒",   "-",       "-"),
        ("400",   "-",        "-",      "1年",    "640毫秒","25毫秒",  "1毫秒",   "-"),
        ("1000",  "-",        "-",      "300年",  "10秒",   "400毫秒", "10毫秒",  "-"),
        ("2000",  "-",        "-",      "2万年",  "1分钟",  "3秒",     "40毫秒",  "2毫秒"),
        ("4000",  "-",        "-",      "130万年","10分钟", "26秒",    "160毫秒", "6毫秒"),
        ("10000", "-",        "-",      "3亿年",  "3小时",  "7分钟",   "1秒",     "40毫秒"),
    ]

    def make_cell(text, color, is_header=False):
        if isinstance(text, str) and text.strip() == "-":
            text = ""
        c = header_color if is_header else color
        m = show_latex(
            scene,
            text,
            x=0,
            y=0,
            run_in=0.0,
            run_out=0.0,
            font=font,
            font_size=font_size,
            buff=text_buff,
            line_gap=0.0,
            baseline=baseline,
            auto_k=auto_k,
            ref_tex=ref_tex,
            show=False,
            color_map=color_map,
            default_color=c,
            add_tex="",
        )
        if m is None:
            return VGroup()
        if isinstance(m, VGroup) and len(m.submobjects) == 1:
            m = m.submobjects[0]
        m.move_to(ORIGIN)
        return m

    header_row = [make_cell(h, default_color, True) for h in headers]
    data_rows = [[make_cell(v, default_color, False) for v in row] for row in data]
    all_rows = [header_row] + data_rows

    n_cols = len(headers)
    col_widths = [0.0] * n_cols
    row_heights = [0.0] * len(all_rows)

    for i, row in enumerate(all_rows):
        rh = 0.0
        for j, cell in enumerate(row):
            w = float(cell.get_width())
            h = float(cell.get_height())
            if w > col_widths[j]:
                col_widths[j] = w
            if h > rh:
                rh = h
        row_heights[i] = rh

    table_rows = []
    for row in all_rows:
        for j, cell in enumerate(row):
            x_left = sum(col_widths[:j]) + j * col_gap
            cur_left = float(cell.get_left()[0])
            cell.shift(RIGHT * (x_left - cur_left))
        table_rows.append(VGroup(*row))

    table = VGroup(*table_rows).arrange(DOWN, buff=row_gap, aligned_edge=LEFT)

    frames = VGroup()
    for i, row in enumerate(all_rows):
        row_grp = table_rows[i]
        y_c = float(row_grp.get_center()[1])
        h_cell = row_heights[i] + 2 * cell_pad_y
        for j, cell in enumerate(row):
            x_l = float(cell.get_left()[0]) - cell_pad_x
            w_cell = col_widths[j] + 2 * cell_pad_x
            r = Rectangle(width=w_cell, height=h_cell).set_fill(opacity=0).set_stroke(border_color, border_width, 1)
            r.move_to(np.array([x_l + w_cell / 2.0, y_c, 0.0]))
            frames.add(r)

    outer = SurroundingRectangle(frames, buff=0).set_fill(opacity=0).set_stroke(border_color, outer_border_width, 1)
    group = VGroup(frames, table, outer)

    if max_width and float(group.get_width()) > max_width:
        group.scale(max_width / float(group.get_width()))
    if max_height and float(group.get_height()) > max_height:
        group.scale(max_height / float(group.get_height()))

    group.move_to(ORIGIN).shift(RIGHT * x + UP * y)

    if show:
        scene.add(group)
        scene.play(FadeIn(group, run_time=run_in))

    scene._algo_time_table = group
    return group

def hide_algo_time_table(scene, table=None, run_out=0.3, remove=True):
    if table is None:
        table = getattr(scene, "_algo_time_table", None)
    if table is None:
        return None
    if run_out > 0:
        scene.play(FadeOut(table, run_time=run_out))
    if remove:
        scene.remove(table)
    if getattr(scene, "_algo_time_table", None) is table:
        scene._algo_time_table = None
    return table

def show_poly_mul(scene, vec_p, vec_q, vec_f, vec_g, sz=SZ_DEFAULT):
    n_p = len(vec_p)
    n_q = len(vec_q)
    n_f = len(vec_f)
    n_g = len(vec_g)
    prod_len = n_p + n_q - 1
    grid_p = make_grid(scene, n_p, 1, mat_l=[vec_p], btn_x=-(prod_len-n_p)*sz/2.0, lgt_x=-(prod_len-n_p)*sz/2.0, btn_y=(n_q+3)*sz/2.0, lgt_y=(n_q+3)*sz/2.0, btn_c=P_COLOR, lgt_c=P_COLOR, sz=sz)
    label_p = add_left_labels(scene, grid_p, ["p"], dx=sz, color=P_COLOR)
    grid_q = make_grid(scene, 1, n_q, mat_l=[[v] for v in vec_q], btn_x=-(prod_len/2.0+2.0)*sz, lgt_x=-(prod_len/2.0+2.0)*sz, btn_c=Q_COLOR, lgt_c=Q_COLOR, sz=sz)
    label_q = add_top_labels(scene, grid_q, ["q"], dy=sz, color=Q_COLOR)
    grid_g = make_grid(scene, prod_len, 1, mat_l=[[0]*prod_len], btn_y=-(n_q+3)*sz/2, lgt_y=-(n_q+3)*sz/2, btn_c=G_COLOR, lgt_c=G_COLOR, sz=sz)
    label_g = add_left_labels(scene, grid_g, ["g"], dx=sz, color=G_COLOR)
    grid_f = make_grid(scene, n_f, 1, mat_l=[vec_f], btn_y=-(n_q+5)*sz/2, lgt_y=-(n_q+5)*sz/2, btn_x=-(prod_len-n_f)*sz/2.0, lgt_x=-(prod_len-n_f)*sz/2.0, btn_c=F_COLOR, lgt_c=F_COLOR, sz=sz)
    label_f = add_left_labels(scene, grid_f, ["f"], dx=sz, color=F_COLOR)
    grid_f2 = make_grid(scene, prod_len, 1, mat_l=[vec_f], btn_y=-(n_q+5)*sz/2, lgt_y=-(n_q+5)*sz/2, btn_x=0, lgt_x=0, btn_c=F_COLOR, lgt_c=F_COLOR, sz=sz, show=False)
    mid_rows = []
    for r in range(n_q):
        grid_row = make_grid(scene, n_p, 1, mat_l=[[0]*n_p], lgt_x=(r-(n_q-1)/2.0)*sz, btn_x=(r-(n_q-1)/2.0)*sz, btn_y=(n_q-1)*sz/2.0-r*sz, lgt_y=(n_q-1)*sz/2.0-r*sz, btn_c=X_COLOR, lgt_c=X_COLOR, sz=sz, rt=0.1)
        mid_rows.append(grid_row)
    mid_rows_cp = []
    mid_rows_p = []
    for r in range(n_q):
        if not vec_q[r]:
            continue
        grid_copy_p = make_grid(scene, n_p, 1, mat_l=[vec_p], btn_x=-(prod_len-n_p)*sz/2.0, lgt_x=-(prod_len-n_p)*sz/2.0, btn_y=(n_q+3)*sz/2.0, lgt_y=(n_q+3)*sz/2.0, btn_c=P_COLOR, lgt_c=P_COLOR, sz=sz, show=False)
        move_grid(scene, grid_copy_p, lgt_x=(r-(n_q-1)/2.0)*sz, btn_x=(r-(n_q-1)/2.0)*sz, lgt_y=(n_q-1)*sz/2.0-r*sz, btn_y=(n_q-1)*sz/2.0-r*sz, sz=None)
        mid_rows_cp.append(grid_copy_p)
        pad_left = r
        pad_right = prod_len - n_p - r
        grid_mid_p = make_grid(scene, prod_len, 1, mat_l=[[0]*pad_left + list(vec_p) + [0]*pad_right], mat_g=[[1 if (i>=pad_left and i<pad_left+n_p) else 0 for i in range(prod_len)]], btn_y=(n_q-1)*sz/2.0-r*sz, lgt_y=(n_q-1)*sz/2.0-r*sz, btn_c=P_COLOR, lgt_c=P_COLOR, sz=sz, show=False)
        mid_rows_p.append(grid_mid_p)
    for grid_mid_p in mid_rows_p:
        add_grid(scene, grid_mid_p, grid_g)
    add_grid(scene, grid_f2, grid_g)
    grid_g2 = make_grid(scene, (n_g-1), 1, mat_l=[vec_g], btn_y=-(n_q+3)*sz/2, lgt_y=-(n_q+3)*sz/2, btn_x=-(prod_len-(n_g-1))*sz/2.0, lgt_x=-(prod_len-(n_g-1))*sz/2.0, btn_c=G_COLOR, lgt_c=G_COLOR, sz=sz)
    del_grids(scene, [grid_g])
    return label_q, label_p, label_g, label_f, grid_p, grid_q, mid_rows, mid_rows_cp, mid_rows_p, grid_g2, grid_f

def clear_poly_mul(scene, ret):
    label_q, label_p, label_g, label_f, grid_p, grid_q, mid_rows, mid_rows_cp, mid_rows_p, grid_g2, grid_f = ret
    del_top_labels(scene, label_q)
    del_left_labels(scene, [label_p, label_g, label_f])
    del_grids(scene, [grid_p, grid_q, mid_rows, mid_rows_cp, mid_rows_p, grid_g2, grid_f])

def make_ops_euclid(mat_f, mat_p):
    def vec_to_int(v):
        x = 0
        for i, b in enumerate(v):
            if b: x |= (1 << i)
        return x
    def poly_deg(x):
        if x == 0: return -1
        return x.bit_length() - 1
    n = max(len(mat_f), len(mat_p))
    F = vec_to_int(mat_f + [0]*(n-len(mat_f)))
    P = vec_to_int(mat_p + [0]*(n-len(mat_p)))
    mask = (1 << n) - 1
    ops = []
    steps = 0
    while F != 0 and P != 0 and steps < 512:
        df = poly_deg(F)
        dp = poly_deg(P)
        if df < dp:
            ops.append(["swap", 0])
            F, P = P, F
            steps += 1
            continue
        shift = df - dp
        if shift > 0:
            ops.append(["addshift", shift])
            F ^= (P << shift) & mask
            steps += 1
        else:
            ops.append(["addshift", 0])
            F ^= P
            steps += 1
    if P == 0 and F != 0:
        ops.append(["swap", 0])
    return ops

def euclid_grids(scene, grids, ops, start=0, end=None, rt=None):
    if not ops: return
    if end is None: end = len(ops) - 1
    if start < 0: start = 0
    if end >= len(ops): end = len(ops) - 1
    f_grid, p_grid, e_grid, o_grid = grids
    for k in range(start, end + 1):
        op, arg = ops[k]
        if op in (0, "add", "ADD", "a", "A"):
            add_grid(scene, A_from=p_grid, A_to=f_grid, B_from=o_grid, B_to=e_grid, rt=rt)
        elif op in (1, "swap", "SWAP", "s", "S"):
            swap_grid(scene, A_from=f_grid, A_to=p_grid, B_from=e_grid, B_to=o_grid, rt=rt)
        elif op in (2, "shift", "SHIFT", "sh", "SH"):
            if arg and arg > 0:
                shift_grid(scene, A_from=p_grid, B_from=o_grid, k=arg, rt=rt)
        elif op in ("addshift", "AS", "as"):
            if arg and arg > 0:
                addshift_grid(scene, A_from=p_grid, A_to=f_grid, B_from=o_grid, B_to=e_grid, k=arg, rt=rt)
            else:
                addshift_grid(scene, A_from=p_grid, A_to=f_grid, B_from=o_grid, B_to=e_grid, k=0, rt=rt)

def euclid_create(scene, vec_f, vec_p, vec_o, vec_e, vec_g, vec_q, color_f, color_p, color_o, color_e, color_g, color_q, dx=2.0, dy=0.5, sz=SZ_DEFAULT, rt=0.3, w=None):
    if w is None: w = len(vec_f)
    rt0 = 0
    grid_f = make_grid(scene, w=w, h=1, lgt_x=-dx, btn_x=-dx, lgt_y=dy, btn_y=dy, sz=sz, mat_l=[vec_f], btn_c=color_f, lgt_c=color_f, rt=rt0)
    grid_p = make_grid(scene, w=w, h=1, lgt_x=-dx, btn_x=-dx, lgt_y=-dy, btn_y=-dy, sz=sz, mat_l=[vec_p], btn_c=color_p, lgt_c=color_p, rt=rt0)
    grid_o = make_grid(scene, w=w, h=1, lgt_x=dx, btn_x=dx, lgt_y=dy, btn_y=dy, sz=sz, mat_l=[vec_o], btn_c=color_o, lgt_c=color_o, rt=rt0)
    grid_e = make_grid(scene, w=w, h=1, lgt_x=dx, btn_x=dx, lgt_y=-dy, btn_y=-dy, sz=sz, mat_l=[vec_e], btn_c=color_e, lgt_c=color_e, rt=rt0)
    vis_f_l = VGroup(*[grid_f["lgt_bd_base"][j][i] for j in range(grid_f["params"].get("h_l", grid_f["params"]["h"])) for i in range(grid_f["params"].get("w_l", grid_f["params"]["w"])) if grid_f["grid_vis_lgt"][j][i]])
    vis_f_b = VGroup(*[grid_f["btn_bd_base"][j][i] for j in range(grid_f["params"]["h"]) for i in range(grid_f["params"]["w"]) if grid_f["grid_vis_btn"][j][i]])
    vis_p_l = VGroup(*[grid_p["lgt_bd_base"][j][i] for j in range(grid_p["params"].get("h_l", grid_p["params"]["h"])) for i in range(grid_p["params"].get("w_l", grid_p["params"]["w"])) if grid_p["grid_vis_lgt"][j][i]])
    vis_p_b = VGroup(*[grid_p["btn_bd_base"][j][i] for j in range(grid_p["params"]["h"]) for i in range(grid_p["params"]["w"]) if grid_p["grid_vis_btn"][j][i]])
    vis_o_l = VGroup(*[grid_o["lgt_bd_base"][j][i] for j in range(grid_o["params"].get("h_l", grid_o["params"]["h"])) for i in range(grid_o["params"].get("w_l", grid_o["params"]["w"])) if grid_o["grid_vis_lgt"][j][i]])
    vis_o_b = VGroup(*[grid_o["btn_bd_base"][j][i] for j in range(grid_o["params"]["h"]) for i in range(grid_o["params"]["w"]) if grid_o["grid_vis_btn"][j][i]])
    vis_e_l = VGroup(*[grid_e["lgt_bd_base"][j][i] for j in range(grid_e["params"].get("h_l", grid_e["params"]["h"])) for i in range(grid_e["params"].get("w_l", grid_e["params"]["w"])) if grid_e["grid_vis_lgt"][j][i]])
    vis_e_b = VGroup(*[grid_e["btn_bd_base"][j][i] for j in range(grid_e["params"]["h"]) for i in range(grid_e["params"]["w"]) if grid_e["grid_vis_btn"][j][i]])
    for g in (vis_f_l, vis_f_b, vis_p_l, vis_p_b, vis_o_l, vis_o_b, vis_e_l, vis_e_b):
        if len(g) > 0: g.set_stroke(opacity=0)
    anims = []
    for g in (vis_f_l, vis_f_b, vis_p_l, vis_p_b, vis_o_l, vis_o_b, vis_e_l, vis_e_b):
        if len(g) > 0: anims.append(g.animate.set_stroke(opacity=1))
    if anims and rt > 0:
        scene.play(*anims, run_time=rt)
    label_f = add_left_labels(scene, grid_f, ["f"], dx=sz, color=color_f, rt=rt0)
    label_p = add_left_labels(scene, grid_p, ["p"], dx=sz, color=color_p, rt=rt0)
    label_o = add_left_labels(scene, grid_o, ["o"], dx=sz, color=color_o, rt=rt0)
    label_e = add_left_labels(scene, grid_e, ["e"], dx=sz, color=color_e, rt=rt0)
    labs = []
    for lst in (label_f, label_p, label_o, label_e):
        if lst:
            for o in lst:
                o.set_opacity(0)
                labs.append(o)
    if labs and rt > 0:
        scene.play(*[o.animate.set_opacity(1) for o in labs], run_time=rt)
    return {"grid_f": grid_f, "grid_p": grid_p, "grid_o": grid_o, "grid_e": grid_e, "label_f": label_f, "label_p": label_p, "label_o": label_o, "label_e": label_e, "vec_g": vec_g, "vec_q": vec_q, "color_g": color_g, "color_q": color_q, "dx": dx, "dy": dy, "sz": sz, "rt": rt, "w": w, "label_g": None, "label_q": None, "grid_g": None, "grid_q": None}

def euclid_ops(scene, euc, ops, start=0, end=None, rt=None):
    grid_f, grid_p, grid_o, grid_e, label_f, label_p, label_o, label_e = euc["grid_f"], euc["grid_p"], euc["grid_o"], euc["grid_e"], euc["label_f"], euc["label_p"], euc["label_o"], euc["label_e"]
    euclid_grids(scene, [grid_f, grid_p, grid_o, grid_e], ops, start=start, end=end, rt=rt)

def euclid_done(scene, euc):
    grid_f, grid_p, grid_o, grid_e, label_f, label_p, label_o, label_e = euc["grid_f"], euc["grid_p"], euc["grid_o"], euc["grid_e"], euc["label_f"], euc["label_p"], euc["label_o"], euc["label_e"]
    vec_g, vec_q, color_g, color_q, dx, dy, sz, rt, w = euc["vec_g"], euc["vec_q"], euc["color_g"], euc["color_q"], euc["dx"], euc["dy"], euc["sz"], euc["rt"], euc["w"]
    if w is None: w = len(vec_g)
    del_left_labels(scene, [label_f, label_o], rt=rt)
    del_grids(scene, [grid_f, grid_o], rt=rt)
    del_left_labels(scene, [label_p, label_e], rt=rt)
    grid_g = make_grid(scene, w=w, h=1, lgt_x=-dx, btn_x=-dx, lgt_y=-dy, btn_y=-dy, sz=sz, mat_l=[vec_g], btn_c=color_g, lgt_c=color_g, show=False)
    grid_q = make_grid(scene, w=w, h=1, lgt_x=+dx, btn_x=+dx, lgt_y=-dy, btn_y=-dy, sz=sz, mat_l=[vec_q], btn_c=color_q, lgt_c=color_q, show=False)
    trans_grid(scene, grid_p, grid_g, rt=rt)
    trans_grid(scene, grid_e, grid_q, rt=rt)
    label_g = add_left_labels(scene, grid_p, ["g"], dx=sz, color=color_g, rt=rt)
    label_q = add_left_labels(scene, grid_e, ["q"], dx=sz, color=color_q, rt=rt)
    euc["label_g"] = label_g
    euc["label_q"] = label_q
    euc["grid_g"] = grid_g
    euc["grid_q"] = grid_q
    return euc

def euclid_clear(scene, euc):
    label_g, label_q, grid_g, grid_q = euc["label_g"], euc["label_q"], euc["grid_g"], euc["grid_q"]
    rt = euc["rt"]
    del_left_labels(scene, [label_g, label_q], rt=rt)
    del_grids(scene, [grid_g, grid_q], rt=rt)

def get_case_params(n):
    sz = SZ_DEFAULT*(7+2)/(n+2)
    szs = sz*SZ_ZOOM_RIGHT
    sx = 5.5
    latex_x, latex_y = 0.0, 2.5
    if n == 5:
        vecB, vecY, vecF, vecK, vecC = VEC_B5, VEC_Y5, VEC_F5, VEC_K5, VEC_C5
        vecP, vecQ, vecG, vecE, vecO = VEC_P5, VEC_Q5, VEC_G5, VEC_E5, VEC_O5
        vecD, vecZ, vecX = VEC_D5, VEC_Z5, VEC_X5
    elif n == 11:
        vecB, vecY, vecF, vecK, vecC = VEC_B11, VEC_Y11, VEC_F11, VEC_K11, VEC_C11
        vecP, vecQ, vecG, vecE, vecO = VEC_P11, VEC_Q11, VEC_G11, VEC_E11, VEC_O11
        vecD, vecZ, vecX = VEC_D11, VEC_Z11, VEC_X11
    elif n == 7:
        vecB, vecY, vecF, vecK, vecC = VEC_B7, VEC_Y7, VEC_F7, VEC_K7, VEC_C7
        vecP, vecQ, vecG, vecE, vecO = VEC_P7, VEC_Q7, VEC_G7, VEC_E7, VEC_O7
        vecD, vecZ, vecX = VEC_D7, VEC_Z7, VEC_X7
    else:
        raise ValueError("unsupported n")
    matY = make_mat_v(n, vecY, "K")
    matD = make_mat_v(n, vecD, "S")
    matT = make_mat_v(n, vecX, "T")
    ops = make_ops_euclid(vecF, vecP)
    return n, sz, szs, sx, matY, matD, matT, vecB, vecY, vecF, vecK, vecC, vecP, vecQ, vecG, vecE, vecO, vecD, vecZ, vecX, latex_x, latex_y, ops

def run_case(scene, n, wait=2, rt=0.2):
    ctx = run_case_begin(scene, n, rt=rt)
    run_case_show_T(scene, ctx)
    scene.wait(wait)
    run_case_del_T(scene, ctx)
    run_case_end(scene, ctx)

def run_case_begin(scene, n, rt=0.01):
    n, sz, szs, sx, matY, matD, matT, vecB, vecY, vecF, vecK, vecC, vecP, vecQ, vecG, vecE, vecO, vecD, vecZ, vecX, latex_x, latex_y, ops = get_case_params(n)

    ctx_B = show_mat(scene, n=n+1, mat_l=MAT_B, mat_g=MAT_MK1, vec=vecB, latex=LATEX_B, color=B_COLOR, label="B", latex_x=latex_x, latex_y=latex_y, sz=sz, rt=rt)
    grid_B = make_grid(scene, n, 1, mat_l=[vecB], lgt_c=B_COLOR, btn_x=sx, lgt_x=sx, btn_y=szs*5, lgt_y=szs*5, sz=szs, show=False)
    trans_grid(scene, ctx_B["grid_v"], grid_B, keep_from=True, rt=rt)
    label_B = add_left_labels(scene, grid_B , ["b"], dx=szs, color=B_COLOR, rt=rt)
    del_mat(scene, ctx_B, rt=rt)

    ctx_Y = show_mat(scene, n=n+1, mat_l=MAT_Y, mat_g=MAT_MK2, vec=vecY, latex=LATEX_Y, color=Y_COLOR, label="Y", latex_x=latex_x, latex_y=latex_y, sz=sz, rt=rt)
    grid_Y = make_grid(scene, n, 1, mat_l=[vecY], lgt_c=Y_COLOR, btn_x=sx, lgt_x=sx, btn_y=szs*4, lgt_y=szs*4, sz=szs, show=False)
    trans_grid(scene, ctx_Y["grid_v"], grid_Y, keep_from=True, rt=rt)
    label_Y = add_left_labels(scene, grid_Y , ["y"], dx=szs, color=Y_COLOR, rt=rt)
    del_mat(scene, ctx_Y, rt=rt)

    ctx_F = show_mat(scene, n=n+1, mat_l=MAT_F, mat_g=MAT_MK1, vec=vecF, latex=LATEX_F, color=F_COLOR, label="F", latex_x=latex_x, latex_y=latex_y, sz=sz, rt=rt)
    grid_F = make_grid(scene, n+1, 1, mat_l=[vecF], lgt_c=F_COLOR, btn_x=sx+szs/2, lgt_x=sx+szs/2, btn_y=szs*3, lgt_y=szs*3, sz=szs, show=False)
    trans_grid(scene, ctx_F["grid_v"], grid_F, keep_from=True, rt=rt)
    label_F = add_left_labels(scene, grid_F , ["f"], dx=szs, color=F_COLOR, rt=rt)
    del_mat(scene, ctx_F, rt=rt)

    ctx_K = show_mat(scene, n=n+1, mat_l=MAT_K, mat_g=MAT_MK1, vec=vecK, latex=LATEX_K, color=K_COLOR, label="K", latex_x=latex_x, latex_y=latex_y, sz=sz, rt=rt)
    grid_K = make_grid(scene, n, 1, mat_l=[vecK], lgt_c=K_COLOR, btn_x=sx, lgt_x=sx, btn_y=szs*2, lgt_y=szs*2, sz=szs, show=False)
    trans_grid(scene, ctx_K["grid_v"], grid_K, keep_from=True, rt=rt)
    label_K = add_left_labels(scene, grid_K , ["k"], dx=szs, color=K_COLOR, rt=rt)
    del_mat(scene, ctx_K, rt=rt)

    ctx_C = show_mat(scene, n=n+1, mat_l=MAT_C, mat_g=MAT_MK1, vec=vecC, latex=LATEX_C, color=C_COLOR, label="C", latex_x=latex_x, latex_y=latex_y, sz=sz, rt=rt)
    grid_C = make_grid(scene, n, 1, mat_l=[vecC], lgt_c=C_COLOR, btn_x=sx, lgt_x=sx, btn_y=szs*1, lgt_y=szs*1, sz=szs, show=False)
    trans_grid(scene, ctx_C["grid_v"], grid_C, keep_from=True, rt=rt)
    label_C = add_left_labels(scene, grid_C , ["c"], dx=szs, color=C_COLOR, rt=rt)
    del_mat(scene, ctx_C, rt=rt)

    lat = show_latex(scene, LATEX_P, latex_x, latex_y, run_in=rt, run_out=rt)
    grid_V = make_grid(scene, 1, n, mat_l=[[v] for v in vecB], btn_x=-(n+3)/2*sz, lgt_x=-(n+3)/2*sz, lgt_c=B_COLOR, sz=sz, rt=rt, show=False)
    trans_grid(scene, grid_B, grid_V, keep_from=True, rt=rt)
    ctx = mul_vec_mat_begin(scene, w=n, h=n, mat=MAT_F, vec=vecB, mat_color=F_COLOR, vec_color=B_COLOR, res_color=P_COLOR, mat_label="F", vec_label="b", res_label="p", sz=sz, rt=rt)
    mul_vec_mat_accumulate(scene, ctx)
    del_grids(scene, [grid_V], rt=0.01)
    grid_P = make_grid(scene, n, 1, mat_l=[vecP], lgt_c=P_COLOR, btn_x=sx, lgt_x=sx, btn_y=szs*0, lgt_y=szs*0, sz=szs, show=False)
    trans_grid(scene, ctx["grid_res"], grid_P, keep_from=True, rt=rt)
    label_P = add_left_labels(scene, grid_P , ["p"], dx=szs, color=P_COLOR, rt=rt)
    mul_vec_mat_cleanup(scene, ctx)
    del_latex(scene, lat, rt=rt)

    lat = show_latex(scene, LATEX_Q, latex_x, latex_y, run_in=rt, run_out=rt)
    dx, dy = 2.0, 0.5
    grid_f = make_grid(scene, w=n+1, h=1, lgt_x=-dx, btn_x=-dx, lgt_y=+dy, btn_y=+dy, sz=sz, mat_l=[vecF], lgt_c=F_COLOR, show=False)
    grid_p = make_grid(scene, w=n+1, h=1, lgt_x=-dx, btn_x=-dx, lgt_y=-dy, btn_y=-dy, sz=sz, mat_l=[vecP], lgt_c=P_COLOR, show=False)
    trans_grid(scene, grid_F, grid_f, keep_from=True, rt=rt)
    trans_grid(scene, grid_P, grid_p, keep_from=True, rt=rt)
    euc = euclid_create(scene, vecF, vecP, vecO, vecE, vecG, vecQ, F_COLOR, P_COLOR, I_COLOR, E_COLOR, G_COLOR, Q_COLOR, sz=sz, rt=rt, dx=dx, dy=dy)
    del_grids(scene, [grid_f, grid_p], rt=0.01)
    euclid_ops(scene, euc, ops, rt=rt)
    euclid_done(scene, euc)
    grid_Q = make_grid(scene, n, 1, mat_l=[vecQ], lgt_c=Q_COLOR, btn_x=sx, lgt_x=sx, btn_y=szs*-1, lgt_y=szs*-1, sz=szs, show=False)
    grid_G = make_grid(scene, n, 1, mat_l=[vecG], lgt_c=G_COLOR, btn_x=sx, lgt_x=sx, btn_y=szs*-2, lgt_y=szs*-2, sz=szs, show=False)
    trans_grid(scene, euc["grid_q"], grid_Q, keep_from=True, rt=rt)
    label_Q = add_left_labels(scene, grid_Q , ["q"], dx=szs, color=Q_COLOR, rt=rt)
    trans_grid(scene, euc["grid_g"], grid_G, keep_from=True, rt=rt)
    label_G = add_left_labels(scene, grid_G , ["g"], dx=szs, color=G_COLOR, rt=rt)
    euclid_clear(scene, euc)
    del_latex(scene, lat, rt=rt)

    lat = show_latex(scene, LATEX_Z, latex_x, latex_y, run_in=rt, run_out=rt)
    grid_V = make_grid(scene, 1, n, mat_l=[[v] for v in vecQ], btn_x=-(n+3)/2*sz, lgt_x=-(n+3)/2*sz, lgt_c=Q_COLOR, sz=sz, rt=rt, show=False)
    grid_M = make_grid(scene, n, 1, mat_l=[vecY], btn_y=+(n-1)/2*sz, lgt_y=+(n-1)/2*sz, lgt_c=Y_COLOR, sz=sz, rt=rt, show=False)
    trans_grid(scene, grid_Q, grid_V, keep_from=True, rt=rt)
    trans_grid(scene, grid_Y, grid_M, keep_from=True, rt=rt)
    ctx = mul_vec_mat_begin(scene, w=n, h=n, mat=matY, vec=vecQ, mat_color=Y_COLOR, vec_color=Q_COLOR, res_color=Z_COLOR, mat_label="Y", vec_label="q", res_label="z", sz=sz, rt=rt)
    mul_vec_mat_accumulate(scene, ctx)
    del_grids(scene, [grid_V, grid_M], rt=0.01)
    grid_Z = make_grid(scene, n, 1, mat_l=[vecZ], lgt_c=Z_COLOR, btn_x=sx, lgt_x=sx, btn_y=szs*-3, lgt_y=szs*-3, sz=szs, show=False)
    trans_grid(scene, ctx["grid_res"], grid_Z, keep_from=True, rt=rt)
    label_Z = add_left_labels(scene, grid_Z , ["z"], dx=szs, color=Z_COLOR, rt=rt)
    mul_vec_mat_cleanup(scene, ctx)
    del_latex(scene, lat, rt=rt)

    lat = show_latex(scene, LATEX_D, latex_x, latex_y, run_in=rt, run_out=rt)
    grid_V = make_grid(scene, 1, n, mat_l=[[v] for v in vecG], btn_x=-(n+3)/2*sz, lgt_x=-(n+3)/2*sz, lgt_c=G_COLOR, sz=sz, rt=rt, show=False)
    trans_grid(scene, grid_G, grid_V, keep_from=True, rt=rt)
    ctx = mul_vec_mat_begin(scene, w=n, h=n, mat=MAT_K, vec=vecG, mat_color=K_COLOR, vec_color=G_COLOR, res_color=D_COLOR, mat_label="K", vec_label="g", res_label="d", sz=sz, rt=rt)
    mul_vec_mat_accumulate(scene, ctx)
    del_grids(scene, [grid_V], rt=0.01)
    grid_D = make_grid(scene, n, 1, mat_l=[vecD], lgt_c=D_COLOR, btn_x=sx, lgt_x=sx, btn_y=szs*-4, lgt_y=szs*-4, sz=szs, show=False)
    trans_grid(scene, ctx["grid_res"], grid_D, keep_from=True, rt=rt)
    label_D = add_left_labels(scene, grid_D , ["d"], dx=szs, color=D_COLOR, rt=rt)
    mul_vec_mat_cleanup(scene, ctx)
    del_latex(scene, lat, rt=rt)

    lat = show_latex(scene, LATEX_X, latex_x, latex_y, run_in=rt, run_out=rt)
    grid_V = make_grid(scene, n, 1, mat_l=[vecZ], btn_y=-(n+3)/2*sz, lgt_y=-(n+3)/2*sz, lgt_c=Z_COLOR, sz=sz, rt=rt, show=False)
    grid_M = make_grid(scene, n, 1, mat_l=[vecD], btn_y=+(n-1)/2*sz, lgt_y=+(n-1)/2*sz, lgt_c=D_COLOR, sz=sz, rt=rt, show=False)
    trans_grid(scene, grid_Z, grid_V, keep_from=True, rt=rt)
    trans_grid(scene, grid_D, grid_M, keep_from=True, rt=rt)
    ctx = mul_vec_mat_begin(scene, w=n, h=n, mat=matD, vec=[0]*n, res=vecZ, mat_color=D_COLOR, vec_color=X_COLOR, res_color=Z_COLOR, mat_label="D", vec_label="x", res_label="z", sz=sz, rt=rt)
    grid_D_ = [None] * n
    for y in range(n):
        grid_D_[y] = make_grid(scene, n, 1, mat_l=[matD[y][:]], btn_y=-(y-(n-1)/2)*sz, lgt_y=-(y-(n-1)/2)*sz, btn_c=D_COLOR, lgt_c=D_COLOR, sz=sz, rt=0.01)
    mul_vec_mat_accumulate(scene, ctx)
    del_grids(scene, [grid_V, grid_M], rt=0.01)
    for i in range(n - 1, -1, -1):
        if vecX[i]:
            toggle_lgt(scene, ctx["grid_vec"], 0, i, rt=rt)
            add_grid(scene, grid_D_[i], ctx["grid_res"], keep_from=True, rt=rt)
    grid_X = make_grid(scene, n, 1, mat_l=[vecX], lgt_c=X_COLOR, btn_x=sx, lgt_x=sx, btn_y=szs*-5, lgt_y=szs*-5, sz=szs, show=False)
    trans_grid(scene, ctx["grid_vec"], grid_X, keep_from=True, rt=rt)
    label_X = add_left_labels(scene, grid_X , ["x"], dx=szs, color=X_COLOR, rt=rt)
    mul_vec_mat_cleanup(scene, ctx)
    del_grids(scene, grid_D_, rt=rt)
    del_latex(scene, lat, rt=rt)

    return {"n": n, "sz": sz, "szs": szs, "sx": sx, "rt": rt, "latex_x": latex_x, "latex_y": latex_y, "matT": matT, "vecX": vecX,
            "grid_B": grid_B, "grid_Y": grid_Y, "grid_F": grid_F, "grid_K": grid_K, "grid_C": grid_C, "grid_P": grid_P, "grid_Q": grid_Q, "grid_G": grid_G, "grid_Z": grid_Z, "grid_D": grid_D, "grid_X": grid_X,
            "label_B": label_B, "label_Y": label_Y, "label_F": label_F, "label_K": label_K, "label_C": label_C, "label_P": label_P, "label_Q": label_Q, "label_G": label_G, "label_Z": label_Z, "label_D": label_D, "label_X": label_X,
            "lat_T": None, "grid_X_": None, "grid_T": None, "label_T": None}

def run_case_show_T(scene, ctx):
    n = ctx["n"]; sz = ctx["sz"]; rt = ctx["rt"]; latex_x = ctx["latex_x"]; latex_y = ctx["latex_y"]; vecX = ctx["vecX"]; grid_X = ctx["grid_X"]; matT = ctx["matT"]
    lat = show_latex(scene, LATEX_T, latex_x, latex_y, run_in=rt, run_out=rt)
    grid_X_ = make_grid(scene, n, 1, mat_l=[vecX], lgt_c=X_COLOR, btn_y=(n-1)/2*sz, lgt_y=(n-1)/2*sz, sz=sz, show=False)
    trans_grid(scene, grid_X, grid_X_, keep_from=True, rt=rt)
    grid_T = make_grid(scene, n, n, mat_l=([[0]*n] + matT[1:]), lgt_c=T_COLOR, sz=sz, rt=rt)
    label_T = add_top_labels(scene, grid_T, [("T" if i==((n-1)//2) else "") for i in range(n)], color=T_COLOR, rt=rt)
    ctx["lat"] = lat; ctx["grid_X_"] = grid_X_; ctx["grid_T"] = grid_T; ctx["label_T"] = label_T

def run_case_del_T(scene, ctx):
    rt = ctx["rt"]; lat = ctx["lat"]; grid_X_ = ctx["grid_X_"]; grid_T = ctx["grid_T"]; label_T = ctx["label_T"]
    del_grids(scene, [grid_X_], rt=rt)
    del_top_labels(scene, label_T, rt=rt)
    del_grids(scene, [grid_T], rt=rt)
    del_latex(scene, lat, rt=rt)

def run_case_end(scene, ctx):
    rt = ctx["rt"]
    label_B = ctx["label_B"]; label_Y = ctx["label_Y"]; label_F = ctx["label_F"]; label_K = ctx["label_K"]; label_C = ctx["label_C"]; label_P = ctx["label_P"]; label_Q = ctx["label_Q"]; label_G = ctx["label_G"]; label_Z = ctx["label_Z"]; label_D = ctx["label_D"]; label_X = ctx["label_X"]
    grid_B = ctx["grid_B"]; grid_Y = ctx["grid_Y"]; grid_F = ctx["grid_F"]; grid_K = ctx["grid_K"]; grid_C = ctx["grid_C"]; grid_P = ctx["grid_P"]; grid_Q = ctx["grid_Q"]; grid_G = ctx["grid_G"]; grid_Z = ctx["grid_Z"]; grid_D = ctx["grid_D"]; grid_X = ctx["grid_X"]
    del_left_labels(scene, [label_B, label_Y, label_F, label_K, label_C, label_P, label_Q, label_G, label_Z, label_D, label_X], rt=rt)
    del_grids(scene, [grid_B, grid_Y, grid_F, grid_K, grid_C, grid_P, grid_Q, grid_G, grid_Z, grid_D, grid_X], rt=rt)

def show_mat(scene, n, mat_l, mat_g, vec, color=WHITE, latex="", latex_x=0.0, latex_y=2.5, label="", sz=SZ_DEFAULT, rt=0.3):
    LAT = show_latex(scene, latex, latex_x, latex_y, run_in=rt, run_out=rt)
    mg = mat_g if isinstance(mat_g, dict) else {"lgt": mat_g, "btn": MAT_MK0}
    grid = make_grid(scene, n, n, mat_l=mat_l, mat_g=mg, btn_c=color, lgt_c=color, sz=sz, rt=rt)
    left_obj = add_left_labels(scene, grid, list(range(n)), dx=sz, rt=rt)
    bottom_obj = add_bottom_label(scene, grid, label, color=color, dy=sz, rt=rt)
    grid_v = make_grid(scene, len(vec), 1, mat_l=[vec], btn_c=color, lgt_c=color, btn_y=-(n-1)*sz/2, lgt_y=-(n-1)*sz/2, btn_x=(len(vec)-n)*sz/2, lgt_x=(len(vec)-n)*sz/2, sz=sz, rt=0.01)
    return {"LAT": LAT, "grid": grid, "grid_v": grid_v, "left_obj": left_obj, "bottom_obj": bottom_obj}

def del_mat(scene, mat_obj, rt=0.3):
    LAT, grid, grid_v, left_obj, bottom_obj = mat_obj["LAT"], mat_obj["grid"], mat_obj["grid_v"], mat_obj["left_obj"], mat_obj["bottom_obj"]
    del_grids(scene, grid_v, rt=0.01)
    del_left_labels(scene, left_obj, rt=rt)
    del_bottom_labels(scene, bottom_obj, rt=rt)
    del_grids(scene, [grid], rt=rt)
    del_latex(scene, LAT, rt=rt)

def make_mat_l(n):
    N=n*n
    A=[[0]*n for _ in range(n)]
    for i in range(n):
        A[i][i]=1
        if i>0:A[i][i-1]=1
        if i<n-1:A[i][i+1]=1
    E=[[1 if i==j else 0 for j in range(n)] for i in range(n)]
    mat=[[0]*N for _ in range(N)]
    for bi in range(n):
        for bj in range(n):
            B=A if bi==bj else E if abs(bi-bj)==1 else None
            if B:
                r=bi*n
                c=bj*n
                for i in range(n):
                    mat[r+i][c:c+n]=B[i][:]
    return mat

def make_mat_b(n):
    I = [[1 if i == j else 0 for i in range(n)] for j in range(n)]
    Z = [[0]*n for _ in range(n)]
    M = [[[0]*n for _ in range(n)] for _ in range(n+1)]
    def v(A, y, x):
        return A[y][x] if 0 <= x < n else 0
    for y in range(n):
        for x in range(n):
            M[0][y][x] = I[y][x]
    for k in range(1, n+1):
        A = M[k-1]
        B = M[k-2] if k-2 >= 0 else Z
        for y in range(n):
            for x in range(n):
                M[k][y][x] = v(A, y, x-1) ^ v(A, y, x) ^ v(A, y, x+1) ^ B[y][x]
    return M

def make_mat_d(n):
    I = [[1 if i == j else 0 for i in range(n)] for j in range(n)]
    Z = [[0]*n for _ in range(n)]
    M = [[[0]*n for _ in range(n)] for _ in range(n+1)]
    def v(A, y, x):
        return A[y][x] if 0 <= x < n else 0
    for y in range(n):
        for x in range(n):
            M[0][y][x] = I[y][x]
    for k in range(1, n+1):
        A = M[k-1]
        B = M[k-2] if k-2 >= 0 else Z
        for y in range(n):
            for x in range(n):
                M[k][y][x] = v(A, y, x-1) ^ v(A, y, x+1)
    return M

def make_mat_y(n):
    def shl(v):
        return [0] + v[:-1]
    def shr(v):
        return v[1:] + [0]
    prev2 = [0]*n
    prev = [0]*n
    rows = []
    rows.append([0]*n)
    for _ in range(n):
        cur = [(prev[j] ^ shl(prev)[j] ^ shr(prev)[j] ^ prev2[j]) ^ 1 for j in range(n)]
        rows.append(cur)
        prev2, prev = prev, cur
    return rows

def make_mat_v(n, vec, kind):
    vec = list(vec)[:n] + [0] * (n - len(vec))
    mat = [[0] * n for _ in range(n)]
    mat[0] = vec[:]
    Z = [0] * n
    def v(row, x):
        return row[x] if 0 <= x < n else 0
    if kind == "Y":
        y_prev = mat[0]
        y_prev2 = Z
        y0_prev = mat[0]
        y0_prev2 = Z
        for t in range(1, n):
            curY = [0] * n
            for x in range(n):
                if x >= t:
                    curY[x] = 0
                else:
                    expr = v(y_prev, x-2) ^ v(y_prev, x-1) ^ v(y_prev, x) ^ v(y_prev2, x-2) ^ v(y0_prev, x-1) ^ v(y0_prev, x) ^ v(y0_prev, x+1) ^ v(y0_prev2, x-1) ^ v(y0_prev2, x)
                    curY[x] = 1 ^ expr
            curY0 = [0] * n
            for x in range(n):
                if x >= t:
                    curY0[x] = 0
                elif x == 0:
                    curY0[x] = curY[x]
                else:
                    curY0[x] = v(y0_prev, x-1) ^ v(y0_prev, x) ^ v(y0_prev, x+1) ^ y0_prev2[x]
            mat[t] = curY
            y_prev2, y_prev = y_prev, curY
            y0_prev2, y0_prev = y0_prev, curY0
        return mat
    prev = mat[0]
    prev2 = Z
    prev3 = Z
    prev4 = Z
    for t in range(1, n):
        cur = [0] * n
        if kind == "K":
            for x in range(n):
                cur[x] = v(prev, x-1) ^ v(prev, x+1)
        elif kind == "S":
            for x in range(n):
                cur[x] = v(prev, x-1) ^ v(prev, x+1) ^ prev2[x]
        elif kind == "B":
            for x in range(n):
                cur[x] = v(prev, x-1) ^ v(prev, x) ^ v(prev, x+1) ^ prev2[x]
        elif kind == "F":
            for x in range(n):
                cur[x] = v(prev, x-1) ^ prev2[x]
        elif kind == "C":
            for x in range(n):
                cur[x] = v(prev, x-1) ^ v(prev, x) ^ prev2[x]
        elif kind == "P":
            for x in range(n):
                cur[x] = v(prev, x) ^ v(prev2, x-1) ^ v(prev2, x-2) ^ v(prev3, x) ^ v(prev4, x)
            if t == 1:
                cur[0] = 1
        elif kind == "T":
            for x in range(n):
                cur[x] = v(prev, x-1) ^ v(prev, x) ^ v(prev, x+1) ^ prev2[x] ^ 1
        else:
            raise ValueError("kind must be one of: 'S','B','K','F','C','P','Y'")
        mat[t] = cur
        prev4, prev3, prev2, prev = prev3, prev2, prev, cur
    return mat

VEC_B5 = [0,1,1,0,1]
VEC_Y5 = [1,0,0,0,1]
VEC_K5 = [0,1,0,0,0]
VEC_F5 = [0,1,0,0,0,1]
VEC_C5 = [0,0,0,0,1]
VEC_P5 = [0,1,0,0,1]
VEC_Q5 = [0,1,0,0,0]
VEC_Q5_2 = [1,1,0,0,0]
VEC_G5 = [0,1,1,0,0,0]
VEC_G5_2 = [0,0,1,0,1,0]
VEC_D5 = [1,1,1,0,0]
VEC_E5 = [1,0,0,0,0]
VEC_O5 = [0,0,0,0,0]
VEC_Z5 = [0,1,0,1,0]
VEC_X5 = [1,1,0,0,0]
VEC_X5_2 = [0,0,0,1,1]

VEC_B7 = [1,0,1,1,0,1,1]
VEC_Y7 = [0,1,0,1,0,1,0]
VEC_K7 = [0,0,0,0,0,0,0]
VEC_F7 = [0,0,0,0,0,0,0,1]
VEC_C7 = [1,1,1,1,1,1,1]
VEC_P7 = [1,1,1,1,1,1,1]
VEC_Q7 = [1,1,0,0,0,0,0]
VEC_G7 = [1,0,0,0,0,0,0,0]
VEC_D7 = [1,0,0,0,0,0,0]
VEC_E7 = [1,0,0,0,0,0,0]
VEC_O7 = [0,0,0,0,0,0,0]
VEC_Z7 = [1,1,0,1,0,1,1]
VEC_X7 = [1,1,0,1,0,1,1]

VEC_B11 = [0,0,0,1,1,1,0,0,0,1,1]
VEC_Y11 = [1,0,1,1,0,0,0,1,1,0,1]
VEC_K11 = [0,0,0,1,0,0,0,0,0,0,0]
VEC_F11 = [0,0,0,1,0,0,0,0,0,0,0,1]
VEC_C11 = [0,0,0,0,0,0,0,0,1,1,1]
VEC_P11 = [0,0,0,1,0,0,0,0,1,1,1]
VEC_Q11 = [0,0,0,1,0,0,0,0,0,0,0]
VEC_G11 = [0,0,0,1,1,1,1,0,0,0,0,0]
VEC_D11 = [1,1,0,1,0,1,1,0,0,0,0]
VEC_E11 = [1,0,0,0,0,0,0,0,0,0,0]
VEC_O11 = [0,0,0,0,0,0,0,0,0,0,0]
VEC_Z11 = [1,1,1,0,0,0,0,0,1,1,1]
VEC_X11 = [1,0,0,0,1,0,0,0,0,0,0]

VEC_V = [0,1,0,0,0,1,0]

VEC_0 = [0,0,0,0,0,0,0,0,0,0,0]
VEC_1 = [1,0,0,0,0,0,0,0,0,0,0]

MAT_H = [
    [0,1,0,0,0,0,0],
    [1,0,1,0,0,0,0],
    [0,1,0,1,0,0,0],
    [0,0,1,0,1,0,0],
    [0,0,0,1,0,1,0],
    [0,0,0,0,1,0,1],
    [0,0,0,0,0,1,0],
]

MAT5B = make_mat_b(5)
MAT5Y = make_mat_y(5)
MAT5D = make_mat_d(5)
MAT7B = make_mat_b(7)
MAT7Y = make_mat_y(7)
MAT7D = make_mat_d(7)

MAT_MK0 = [[0]*12 for _ in range(12)]
MAT_MK1 = [[1 if j <= i else 0 for j in range(12)] for i in range(12)]
MAT_MK2 = [[1 if j < i else 0 for j in range(12)] for i in range(12)]

MAT_B = make_mat_v(12, VEC_1, "B")
MAT_Y = make_mat_v(12, VEC_0, "Y")
MAT_K = make_mat_v(12, VEC_1, "K")
MAT_F = make_mat_v(12, VEC_1, "F")
MAT_C = make_mat_v(12, VEC_1, "C")
MAT_P = make_mat_v(12, VEC_0, "P")
MAT_G = [
    [1,0,0,0,0,0,0,0,0,0,0],
    [1,0,0,0,0,0,0,0,0,0,0],
    [1,0,0,0,0,0,0,0,0,0,0],
    [1,0,0,0,0,0,0,0,0,0,0],
    [1,0,1,0,1,0,0,0,0,0,0],
    [0,1,1,0,0,0,0,0,0,0,0],
    [1,0,0,0,0,0,0,0,0,0,0],
    [1,0,0,0,0,0,0,0,0,0,0],
    [1,0,0,0,0,0,0,0,0,0,0],
    [1,0,0,0,1,0,0,0,1,0,0],
    [1,0,0,0,0,0,0,0,0,0,0],
]
MAT_Q = [
    [0,0,0,0,0,0,0,0,0,0,0],
    [1,0,0,0,0,0,0,0,0,0,0],
    [1,0,0,0,0,0,0,0,0,0,0],
    [1,1,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0],
    [0,1,0,0,0,0,0,0,0,0,0],
    [0,0,1,0,0,0,0,0,0,0,0],
    [1,1,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,1,0,0,0,0,0,0],
    [1,0,0,0,0,0,0,0,0,0,0],
    [1,0,1,0,0,0,0,0,0,0,0],
]


MAT_B5 = make_mat_v(5, VEC_B5, "S")
MAT_Q5_1 = make_mat_v(5, VEC_Q5, "S")
MAT_Q5_2 = make_mat_v(5, VEC_Q5_2, "S")
MAT_Q5 = [
    [1,1,0,0,0],
    [1,1,1,0,0],
    [0,1,1,0,0],
    [0,1,1,1,0],
    [1,0,1,0,1],
]
MAT_E5 = [
    [1,0,0,0,1],
    [0,1,0,1,0],
    [0,0,1,1,1],
    [0,0,0,0,0],
    [0,0,0,0,0],
]
MAT_D5 = make_mat_v(5, VEC_D5, "S")
MAT_Q7 = make_mat_v(7, VEC_Q7, "S")
MAT_Y7 = make_mat_v(7, VEC_Y7, "K")

OPS_5 = make_ops_euclid(VEC_F5, VEC_P5)
OPS_7 = make_ops_euclid(VEC_F7, VEC_P7)

LATEX_LEFT = [
    {"type": "text", "content": "[1] Jaap Scherphuis，《点灯问题游戏的数学原理》", "scale": SCALE_CENTER, "indent": 0.0},
    {"type": "text", "content": "https://www.jaapsch.net/puzzles/lomath.htm", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "[2] Granvallen，《点灯游戏与数学之美》", "scale": SCALE_CENTER, "indent": 0.0},
    {"type": "text", "content": "https://granvallen.github.io/lightoutgame/","scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "[3] axpokl，《点灯游戏Flip Game的O(n³)算法》", "scale": SCALE_CENTER, "indent": 0.0},
    {"type": "text", "content": "https://zhuanlan.zhihu.com/p/53646257", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "[4] Chao Xu，《逼零集、点灯游戏与线性方程组》", "scale": SCALE_CENTER, "indent": 0.0},
    {"type": "text", "content": "https://zhuanlan.zhihu.com/p/553780037","scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "[5] GitHub — axpokl，《点灯问题O(n²)Pascal求解》", "scale": SCALE_CENTER, "indent": 0.0},
    {"type": "text", "content": "https://github.com/axpokl/LightOut","scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "[6] GitHub — njpipeorgan，《大规模点灯问题求解器》", "scale": SCALE_CENTER, "indent": 0.0},
    {"type": "text", "content": "https://github.com/njpipeorgan/LightsOut", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "[7] OEIS，《n×n 全亮点灯问题的解数》", "scale": SCALE_CENTER, "indent": 0.0},
    {"type": "text", "content": "https://oeis.org/A075462", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "[8] OEIS，《n×n 全亮点灯问题的秩缺陷》", "scale": SCALE_CENTER, "indent": 0.0},
    {"type": "text", "content": "https://oeis.org/A159257", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
]

LATEX_CENTER = [
    {"type": "text", "content": "[9] Tamar E. Wilson，《点灯游戏：判定矩形棋盘的可解性》", "scale": SCALE_CENTER, "indent": 0.0},
    {"type": "text", "content": "https://ida.mtholyoke.edu/server/api/core/bitstreams", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "/269795c9-18b9-44b5-ba88-1d4a422008da/content", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "[10] Anil Damle，《克雷洛夫方法》", "scale": SCALE_CENTER, "indent": 0.0},
    {"type": "text", "content": "https://www.cs.cornell.edu/courses/cs6220/2017fa/CS6220_Lecture8.pdf", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "[11] Douglas H. Wiedemann，《在有限域上求解稀疏线性方程》", "scale": SCALE_CENTER, "indent": 0.0},
    {"type": "text", "content": "https://www.enseignement.polytechnique.fr", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "/informatique/profs/Francois.Morain", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "/Master1/Crypto/projects/Wiedemann86.pdf", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "[12] Erich Kaltofen，《关于Wiedemann求解稀疏线性系统方法》", "scale": SCALE_CENTER, "indent": 0.0},
    {"type": "text", "content": "https://users.cs.duke.edu/~elk27/bibliography/91/KaSa91.pdf", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "[13] John L. Goldwasser，《网格图中的奇偶支配集》", "scale": SCALE_CENTER, "indent": 0.0},
    {"type": "text", "content": "https://www.researchgate.net/profile/John-Goldwasser", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "/publication/250342861_Parity_Dominating_Sets_in_Grid_Graphs", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "/links/56ec5c4008ae4b8b5e7334f3", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "/Parity-Dominating-Sets-in-Grid-Graphs.pdf", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
]

LATEX_RIGHT = [
    {"type": "text", "content": "本视频由 ManimGL 制作：", "scale": SCALE_CENTER, "indent": 0.0},
    {"type": "text", "content": "https://github.com/3b1b/manim", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "视频脚本：", "scale": SCALE_CENTER, "indent": 0.0},
    {"type": "text", "content": "https://github.com/axpokl/LightOut", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "/blob/master/lights_out_manim2.py", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "Pascal语言算法实现：", "scale": SCALE_CENTER, "indent": 0.0},
    {"type": "text", "content": "https://github.com/axpokl/LightOut", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "/blob/master/diandeng10_a_faster2_png_H13.pas", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "点灯游戏安卓 APK（含 O(n³) 求解）：","scale": SCALE_CENTER, "indent": 0.0},
    {"type": "text", "content": "https://axpokl.com/cx/axdiandeng2.apk", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "维基百科，《克雷洛夫子空间》", "scale": SCALE_CENTER, "indent": 0.0},
    {"type": "text", "content": "https://zh.wikipedia.org/wiki/克雷洛夫子空间", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "维基百科，《邻接矩阵》", "scale": SCALE_CENTER, "indent": 0.0},
    {"type": "text", "content": "https://zh.wikipedia.org/wiki/邻接矩阵", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
    {"type": "text", "content": "维基百科，《常对角矩阵》", "scale": SCALE_CENTER, "indent": 0.0},
    {"type": "text", "content": "https://zh.wikipedia.org/wiki/常对角矩阵", "scale": SCALE_CENTER_URL, "indent": SCALE_CENTER_INDENT},
]

LATEX_MAT = [
    (L_COLOR, "<cL>", "L", "-", "灯矩阵第一行", "公式递推", "<cL>L(n,x)=L(n-1,x-1)⊕L(n-1,x)⊕L(n-1,x+1)⊕L(n-2,x)"),
    (B_COLOR, "<cB>", "B", "-", "按钮矩阵第一行", "公式递推", "<cB>B(n,x)=B(n-1,x-1)⊕B(n-1,x)⊕B(n-1,x+1)⊕B(n-2,x)"),
    (Y_COLOR, "<cY>", "Y", "-", "灯矩阵最后一行", "公式递推", "<cY>Y(n,y)=¬(Y(n-1,y-1)⊕Y(n-1,y)⊕Y(n-1,y+1)⊕Y(n-2,y))"),
    (H_COLOR, "<cH>", "H", "-", "邻接扩散矩阵", "公式递推", "<cH>H(x,y)=(|x-y|=1)"),
    (K_COLOR, "<cK>", "K", "<cH>H", "Hⁿ第一行（Krylov扩散基矩阵）", "公式递推", "<cK>K(n,x)=K(n-1,x-1)⊕K(n-1,x+1)"),
    (F_COLOR, "<cF>", "F", "<cK>K", "K的逆矩阵（Krylov解耦矩阵）", "公式递推", "<cF>F(n,x)=F(n-1,x-1)⊕F(n-2,x)"),
    (C_COLOR, "<cC>", "C", "<cB>B", "B关于H的系数矩阵", "公式递推", "<cC>C(n,x)=C(n-1,x-1)⊕C(n-1,x)⊕C(n-2,x)"),
    (P_COLOR, "<cP>", "p", "<cF>F<cP>,<cB>b", "多项式p(H)的系数", "矩阵向量乘法", "<cP>p=<cF>F<cB>b"),
    (Q_COLOR, "<cQ>", "q", "<cF>f<cQ>,<cP>p", "多项式p(x)的在f(x)下的逆", "扩展欧几里得", "<cQ>q=<cP>p⁻¹<cQ> mod <cF>F"),
    (G_COLOR, "<cG>", "g", "<cF>f<cG>,<cP>p", "多项式p(x)和q(x)最大共因子", "扩展欧几里得", "<cG>g=gcd(<cF>f<cG>,<cC>c<cG>)=gcd(<cF>f<cG>,<cP>p<cG>)"),
    (Z_COLOR, "<cZ>", "z", "<cQ>Y<cZ>,<cY>q", "部分逆按钮解", "矩阵向量乘法", "<cZ>z=<cQ>Q<cY>y"),
    (D_COLOR, "<cD>", "d", "<cK>K<cD>,<cG>g", "多项式g(x)的矩阵", "矩阵向量乘法", "<cD>d=<cK>K<cG>g"),
    (X_COLOR, "<cX>", "x", "<cD>D<cX>,<cZ>z", "最终首行按钮解", "前向异或消元", "<cZ>z=<cD>D<cX>x"),
    (T_COLOR, "<cT>", "T", "<cX>x", "最终按钮解矩阵", "公式递推", "<cT>T(n,x)=¬(T(n-1,x-1)⊕T(n-1,x)⊕T(n-1,x+1)⊕T(n-2,x))"),
]

(
 LATEX_L,
 LATEX_B,
 LATEX_Y,
 LATEX_H,
 LATEX_K,
 LATEX_F,
 LATEX_C,
 LATEX_P,
 LATEX_Q,
 LATEX_G,
 LATEX_Z,
 LATEX_D,
 LATEX_X,
 LATEX_T
) = [
    f"{row[6]}"
    for row in LATEX_MAT
]

class LightsOut(Scene):
    def construct(self):
        self.camera.background_color = BLACK

        """
        LAT1 = show_latex(self, "<cI>5×5⨯5⨉5✕5∑⊕·…", 0, 1.0)
        LAT1 = show_latex(self, "<cI>₁₂₃₄₅₆₇₈₉ᵃ ᵇ ᶜ ᵈ ᵉ ᶠ ᵍ ʰ ⁱ ʲ ᵏ ˡ ᵐ ⁿ ᵒ ᵖ ʳ ˢ ᵗ ᵘ ᵛ ʷ ˣ ʸ ᶻ⁻¹Q⊕  ⨁  ·  ∙  ⋅  ⋯  …  ¬  ₀  ⁻¹", 0, 0.5)

        show_subtitle(self, "r×r⨯r⨉r✕r∑⊕·…")
        show_subtitle(self, "₁₂₃₄₅₆₇₈₉ᵃ ᵇ ᶜ ᵈ ᵉ ᶠ ᵍ ʰ ⁱ ʲ ᵏ ˡ ᵐ ⁿ ᵒ ᵖ ʳ ˢ ᵗ ᵘ ᵛ ʷ ˣ ʸ ᶻ⁻¹Q⊕  ⨁  ·  ∙  ⋅  ⋯  …  ¬  ₀  ⁻¹")
        """

        show_title(self, "点灯游戏的O(n²)解法")

        sx = 5.5
        sy = 3
        rt = 0.3

        sz5 = SZ_DEFAULT*(7+2)/(5+2)*SZ_ZOOM_RIGHT
        sz7 = SZ_DEFAULT*(7+2)/(7+2)*SZ_ZOOM_RIGHT
        sz11 = SZ_DEFAULT*(7+2)/(11+2)*SZ_ZOOM_RIGHT

        ctx = run_case_begin(self, 5)
        grid_X5 = make_grid(scene, 5, 1, mat_l=[VEC_X5], lgt_c=X_COLOR, btn_x=sx, lgt_x=sx, btn_y=sy, lgt_y=sy, sz=sz5, show=False)
        trans_grid(self, ctx["grid_X"], grid_X5, keep_from=True, rt=rt)
        run_case_end(self, ctx)
        sy = sy - sz5
        ctx = run_case_begin(self, 7)
        grid_X7 = make_grid(scene, 7, 1, mat_l=[VEC_X7], lgt_c=X_COLOR, btn_x=sx, lgt_x=sx, btn_y=sy, lgt_y=sy, sz=sz7, show=False)
        trans_grid(self, ctx["grid_X"], grid_X7, keep_from=True, rt=rt)
        run_case_end(self, ctx)
        sy = sy - sz7
        ctx = run_case_begin(self, 11)
        grid_X11 = make_grid(scene, 11, 1, mat_l=[VEC_X11], lgt_c=X_COLOR, btn_x=sx, lgt_x=sx, btn_y=sy, lgt_y=sy, sz=sz11, show=False)
        trans_grid(self, ctx["grid_X"], grid_X11, keep_from=True, rt=rt)
        run_case_end(self, ctx)

        sz5 = SZ_DEFAULT*(7+2)/(5+2)*SZ_ZOOM_MID
        sz7 = SZ_DEFAULT*(7+2)/(7+2)*SZ_ZOOM_MID
        sz11 = SZ_DEFAULT*(7+2)/(11+2)*SZ_ZOOM_MID

        move_grid(self, grid_X5, lgt_x=-4.5, btn_x=-4.5, lgt_y=sz5*2, btn_y=sz5*2, rt=rt, sz=sz5)
        move_grid(self, grid_X7, lgt_x=0.0, btn_x=0.0, lgt_y=sz7*3, btn_y=sz7*3, rt=rt, sz=sz7)
        move_grid(self, grid_X11, lgt_x=4.5, btn_x=4.5, lgt_y=sz11*5, btn_y=sz11*5, rt=rt, sz=sz11)

        grid_X5_  = make_grid(self,  5,  5, mat_l=([[0]*5]  + make_mat_v( 5, VEC_X5,  "T")[1:]), lgt_c=T_COLOR, lgt_x=-4.5, btn_x=-4.5, rt=rt, sz=sz5)
        bottom_obj5 = add_bottom_label(self, grid_X5_, "N=5", color=T_COLOR)
        grid_X7_  = make_grid(self,  7,  7, mat_l=([[0]*7]  + make_mat_v( 7, VEC_X7,  "T")[1:]), lgt_c=T_COLOR, lgt_x= 0.0, btn_x= 0.0, rt=rt, sz=sz7)
        bottom_obj7 = add_bottom_label(self, grid_X7_, "N=7", color=T_COLOR)
        grid_X11_ = make_grid(self, 11, 11, mat_l=([[0]*11] + make_mat_v(11, VEC_X11, "T")[1:]), lgt_c=T_COLOR, lgt_x= 4.5, btn_x= 4.5, rt=rt, sz=sz11)
        bottom_obj11 = add_bottom_label(self, grid_X11_, "N=11", color=T_COLOR)

        self.wait(3)

        del_bottom_labels(self, [bottom_obj5, bottom_obj7, bottom_obj11])
        del_grids(self, [grid_X5, grid_X7, grid_X11, grid_X5_, grid_X7_, grid_X11_], rt=rt)

#——————————————————————

        show_title(self, "首行叠加法（续上集）")

        show_subtitle(self, "在上集视频的《首行叠加法》中，有小伙伴对按钮和灯的递推仍有疑问。", "这次我们来讲清楚，这个递推公式是怎么来的。")
        LAT1 = show_latex(self, "<cB>B(n,x)=B(n-1,x-1)⊕B(n-1,x)⊕B(n-1,x+1)⊕B(n-2,x)", 0, 2.0)
        LAT2 = show_latex(self, "<cB>B按钮    <cL>L灯    <cH1>⊕叠加    <cH2>¬翻转", 0, 1.5)
        self.wait(10)

        show_subtitle(self, "我们用B代表按钮，L代表灯，⊕（加）代表叠加，¬（非）代表翻转。")
        sz=SZ_SMALL
        cols, rows = 5, 5
        G5_ = [[None] * cols for _ in range(rows)]
        G5Y_ = [[None] * cols for _ in range(rows)]
        top_objs = [[None] * cols for _ in range(rows)]
        topy_objs = [[None] * cols for _ in range(rows)]
        left_objs = [[None] * cols for _ in range(rows)]
        for k in range(rows):
            for y in range(cols):
                mx = (y*2-cols)*(1+sz)+1
                my = -k*sz
                G5_[k][y] = make_grid(self, w=cols, h=1, lgt_x=mx, btn_x=mx, lgt_y=my, btn_y=my, sz=SZ_SMALL, mat=[MAT5B[k][y][:]], mat_l=[MAT5B[k+1][y][:]], show=True, rt=0.05)
                mx = (y*2-cols)*(1+sz)+1+sz*(cols+3)/2
                G5Y_[k][y] = make_grid(self, w=1, h=1, lgt_x=mx, btn_x=mx, lgt_y=my, btn_y=my, sz=SZ_SMALL, mat=[[MAT5Y[k][y]]], mat_l=[[MAT5Y[k+1][y]]],show=True, rt=0.05)
                if k == 0: top_objs[k][y] = add_top_labels(self, G5_[k][y], ["x1","x2","x3","x4","x5"], rt=0.01)
                if k == 0: topy_objs[k][y] = add_top_labels(self, G5Y_[k][y], [f"y{y+1}"], rt=0.01)
                left_objs[k][y] = add_left_labels(self, G5_[k][y], [f"n{k+1}"], rt=0.01)
        self.wait(2)

        show_subtitle(self, "n代表从上到下第n行按钮或灯。", "因为我们是一行行进行推导的，n也代表第n次推导。")
        n_frames = hl_objs(self, [left_objs], width=BD_W)
        self.wait(8.5)
        del_hl_objs(self, n_frames)
        show_subtitle(self, "x代表从左到右第x列按钮。我们将灯表示为第一行的某几个列的按钮的叠加。", "这里的x不局限于第一行。")
        x_frames = hl_objs(self, [top_objs], width=BD_W)
        self.wait(10.5)
        del_hl_objs(self, x_frames)
        show_subtitle(self, "y代表从左到右第y列灯。", "这里的公式对任意第y个灯都满足，所以省去了y。")
        y_frames = hl_objs(self, [topy_objs], width=BD_W)
        lat_frames = hl_objs(self, [LAT1], width=BD_W_SEL/2)
        self.wait(8)
        del_hl_objs(self, y_frames)
        del_hl_objs(self, lat_frames)

        show_subtitle(self, "在这里，粉色原点是用按钮表示按钮，淡蓝色方块是用按钮表示灯。")
        mat_0 = [[0] * cols]
        mat_lgt = []
        mat_btn = []
        mat_lgt_y = []
        mat_btn_y = []
        for k in range(rows):
            row_lgt = []
            row_btn = []
            row_lgt_y = []
            row_btn_y = []
            for y in range(cols):
                row_lgt.append([MAT5B[k+1][y][:]])
                row_btn.append([MAT5B[k][y][:]])
                row_lgt_y.append([[MAT5Y[k+1][y]]])
                row_btn_y.append([[MAT5Y[k][y]]])
            mat_lgt.append(row_lgt)
            mat_btn.append(row_btn)
            mat_lgt_y.append(row_lgt_y)
            mat_btn_y.append(row_btn_y)
        set_grid_mats(self, grids=G5_, mat=mat_btn, mat_l=mat_0, clear_first=False)
        set_grid_mats(self, grids=G5Y_, mat=mat_btn_y, mat_l=mat_0, clear_first=False)
        self.wait(3)
        set_grid_mats(self, grids=G5_, mat=mat_0, mat_l=mat_lgt, clear_first=False)
        set_grid_mats(self, grids=G5Y_, mat=mat_0, mat_l=mat_lgt_y, clear_first=False)
        self.wait(3)

        show_subtitle(self, "而在上集视频中，因为最终目标是将灯用按钮表示，", "因此省去了按钮表示按钮，粉色原点直接是按钮表示灯。")
        set_grid_mats(self, grids=G5_, mat=mat_lgt, mat_l=mat_0, clear_first=False)
        set_grid_mats(self, grids=G5Y_, mat=mat_lgt_y, mat_l=mat_0, clear_first=False)
        self.wait(9)

        del_latex(self, [LAT1, LAT2]);
        del_top_labels(self, top_objs)
        del_top_labels(self, topy_objs)
        del_left_labels(self, left_objs)
        del_grids(self, G5_);
        del_grids(self, G5Y_);

        show_subtitle(self, "让我们举一个具体的例子。", "在5×5的格子中，我们将按钮和灯编号为1—25。")
        sz=SZ_SMALLER
        cols, rows = 5, 5
        G5 = make_grid(self, w=cols, h=rows, lgt_x=-4, btn_x=-4)
        objs = add_grid_labels(self, G5, [[f"B{c*rows + r + 1}" for c in range(cols)] for r in range(rows)])
        self.wait(7)

        show_subtitle(self, "在《叠加法》中，我们将灯表示为所有按钮的叠加。", "例如：L1=B1⊕B2⊕B6，L6=B1⊕B6⊕B7⊕B11。")
        G5_ = [[None] * cols for _ in range(rows)]
        mat_l = make_mat_l(rows)
        btn_objs = [[None] * cols for _ in range(rows)]
        lgt_objs = [[None] * cols for _ in range(rows)]
        for y in range(rows):
            for x in range(cols):
                idx = y * cols + x
                my = ((rows * cols) - 1) * sz / 2 - idx * sz
                G5_[y][x] = make_grid(self, w=cols * rows, h=1, w_l=1, h_l=1, lgt_x=3, btn_x=0, lgt_y=my, btn_y=my, sz=SZ_SMALLER, rt=0.01, mat=[mat_l[idx][:]], mat_l=[[1]], show=False)
                rt = 0.15
                press_rev(self, G5, x,y, rt=rt / 5)
                trans_grid(self,G5,G5_[y][x], keep_from=True, rt=rt);
                btn_objs[y][x] = add_grid_labels(self, G5_[y][x], [[f"B{j+1}" for j in range(cols*rows)]], rt=0.01)
                lgt_objs[y][x] = add_grid_labels(self, G5_[y][x], [[f"L{idx+1}"]], rt=0.01)
                del_grids(self, [G5], kp_bd=True , rt=rt /5) 
        self.wait(5)

        show_subtitle(self, "通过这种方法，我们得到了25个未知数的一次方程组。", "我们将其写成增广矩阵，也就是按钮矩阵和翻转向量，即灯向量的形式。")
        self.wait(11.5)
        del_grid_labels(self, objs)
        del_grids(self, [G5]) 
        del_grid_labels(self, btn_objs)
        del_grid_labels(self, lgt_objs)
        del_grids(self, [G5_]) 

        show_subtitle(self, "而在《首行叠加法》中，我们需要把灯表示为第一行按钮的叠加。")
        sz=SZ_SMALL
        cols, rows = 5, 5
        G5_ = [[None] * cols for _ in range(rows)]
        G5Y_ = [[None] * cols for _ in range(rows)]
        top_objs = [[None] * cols for _ in range(rows)]
        topy_objs = [[None] * cols for _ in range(rows)]
        left_objs = [[None] * cols for _ in range(rows)]
        for k in range(rows):
            for y in range(cols):
                mx = (y*2-cols)*(1+sz)+1
                my = -k*sz
                G5_[k][y] = make_grid(self, w=cols, h=1, lgt_x=mx, btn_x=mx, lgt_y=my, btn_y=my, sz=SZ_SMALL, mat=[[0]*cols], mat_l=[[0]*cols], show=True, rt=0.01)
                mx = (y*2-cols)*(1+sz)+1+sz*(cols+3)/2
                G5Y_[k][y] = make_grid(self, w=1, h=1, lgt_x=mx, btn_x=mx, lgt_y=my, btn_y=my, sz=SZ_SMALL, mat=[[0]*cols for _ in range(rows)], mat_l=[[0]], show=True, rt=0.01)
                if k == 0: top_objs[k][y] = add_top_labels(self, G5_[k][y], ["B1","B2","B3","B4","B5"], rt=0.01)
                if k == 0: topy_objs[k][y] = add_top_labels(self, G5Y_[k][y], [f"L{y+1}"], rt=0.01)
                left_objs[k][y] = add_left_labels(self, G5_[k][y], [f"{ k*cols + y + 1 }"], rt=0.01)
        self.wait(3)

        show_subtitle(self, "这里的五个矩阵，", "分别代表第y列是由第一行的哪几个按钮叠加的。")
        self.wait(6)
        show_subtitle(self, "由于按法是动态的，当第二行按钮还未被按下时，", "L1=B1⊕B2，即第一个灯L1是由第一行的第一、第二个按钮B1,B2叠加的。")
        toggle_lgt(self, G5_[0][0], 0, 0)
        toggle_lgt(self, G5_[0][0], 1, 0)
        self.wait(12)

        show_subtitle(self, "然后，B6=¬L1=¬(B1⊕B2)，即第六个按钮B6是第一个灯L1的翻转。", "因此，第二行按钮B6和第一行灯L1的叠加状态是相同的。")
        toggle_btn(self, G5_[1][0], 0, 0)
        toggle_btn(self, G5_[1][0], 1, 0)
        self.wait(13.5)
        
        show_subtitle(self, "只不过B6是L1的翻转。", "而旁边的翻转向量，代表的就是按钮或灯有没有翻转。")
        toggle_lgt(self, G5Y_[0][0], 0, 0)
        toggle_btn(self, G5Y_[1][0], 0, 0)
        self.wait(8.5)

        show_subtitle(self, "例如，当第一个向量的第一个灯L1亮起时，", "表示L1除了由刚才说的按钮叠加外，还需要翻转才是正确的状态。")
        self.wait(10)

        show_subtitle(self, "同理，B7=¬L2=¬(B1⊕B2⊕B3)，即第七个按钮B7是第二个灯L2的翻转。", "同样，第二行的按钮B7和第一行灯L2的叠加状态是相同的。")
        toggle_lgt(self, G5_[0][1], 0, 0)
        toggle_lgt(self, G5_[0][1], 1, 0)
        toggle_lgt(self, G5_[0][1], 2, 0)
        toggle_btn(self, G5_[1][1], 0, 0)
        toggle_btn(self, G5_[1][1], 1, 0)
        toggle_btn(self, G5_[1][1], 2, 0)
        toggle_lgt(self, G5Y_[0][1], 0, 0)
        toggle_btn(self, G5Y_[1][1], 0, 0)
        self.wait(13)

        show_subtitle(self, "这里，我们将第一个按钮B1的状态补全，", "将B1用第一行的按钮叠加时，有B1=B1。")
        toggle_btn(self, G5_[0][0], 0, 0)
        self.wait(8)

        show_subtitle(self, "接下来我们来看第六个灯。", "L6=B1⊕B6⊕B7=B1⊕¬(B1⊕B2)⊕¬(B1⊕B2⊕B3)=B1⊕B3。")
        hl_cells(self, [G5_[0][0]], indices=[(0, 0)])
        hl_cells(self, [G5_[1][0]], indices=[(0, 0)])
        hl_cells(self, [G5_[1][0]], indices=[(1, 0)])
        hl_cells(self, [G5_[1][1]], indices=[(0, 0)])
        hl_cells(self, [G5_[1][1]], indices=[(1, 0)])
        hl_cells(self, [G5_[1][1]], indices=[(2, 0)])
        self.wait(1)
        add_cell(self, G5_[0][0], G5_[1][0], 0, 0, 0, 0, color_from=HL_COLOR_1, color_to=HL_COLOR_2)
        add_cell(self, G5_[1][0], G5_[1][0], 0, 0, 0, 0, color_from=HL_COLOR_1, color_to=HL_COLOR_2)
        add_cell(self, G5_[1][0], G5_[1][0], 1, 0, 1, 0, color_from=HL_COLOR_1, color_to=HL_COLOR_2)
        add_cell(self, G5_[1][1], G5_[1][0], 0, 0, 0, 0, color_from=HL_COLOR_1, color_to=HL_COLOR_2)
        add_cell(self, G5_[1][1], G5_[1][0], 1, 0, 1, 0, color_from=HL_COLOR_1, color_to=HL_COLOR_2)
        add_cell(self, G5_[1][1], G5_[1][0], 2, 0, 2, 0, color_from=HL_COLOR_1, color_to=HL_COLOR_2)
        self.wait(1)

        show_subtitle(self, "又比如，L7=B2⊕B6⊕B7⊕B8", "=B2⊕¬(B1⊕B2)⊕¬(B1⊕B2⊕B3)⊕¬(B2⊕B3⊕B4)=¬B4。")
        toggle_btn(self, G5_[0][1], 1, 0, rt=0.2)
        toggle_btn(self, G5_[1][2], 1, 0, rt=0.2)
        toggle_btn(self, G5_[1][2], 2, 0, rt=0.2)
        toggle_btn(self, G5_[1][2], 3, 0, rt=0.2)
        hl_cells(self, [G5_[0][1]], indices=[(1, 0)], rt=0.2)
        hl_cells(self, [G5_[1][0]], indices=[(0, 0)], rt=0.2)
        hl_cells(self, [G5_[1][0]], indices=[(1, 0)], rt=0.2)
        hl_cells(self, [G5_[1][1]], indices=[(0, 0)], rt=0.2)
        hl_cells(self, [G5_[1][1]], indices=[(1, 0)], rt=0.2)
        hl_cells(self, [G5_[1][1]], indices=[(2, 0)], rt=0.2)
        hl_cells(self, [G5_[1][2]], indices=[(1, 0)], rt=0.2)
        hl_cells(self, [G5_[1][2]], indices=[(2, 0)], rt=0.2)
        hl_cells(self, [G5_[1][2]], indices=[(3, 0)], rt=0.2)
        add_cell(self, G5_[0][1], G5_[1][1], 1, 0, 1, 0, color_from=HL_COLOR_1, color_to=HL_COLOR_2, rt=0.2)
        add_cell(self, G5_[1][0], G5_[1][1], 0, 0, 0, 0, color_from=HL_COLOR_1, color_to=HL_COLOR_2, rt=0.2)
        add_cell(self, G5_[1][0], G5_[1][1], 1, 0, 1, 0, color_from=HL_COLOR_1, color_to=HL_COLOR_2, rt=0.2)
        add_cell(self, G5_[1][1], G5_[1][1], 0, 0, 0, 0, color_from=HL_COLOR_1, color_to=HL_COLOR_2, rt=0.2)
        add_cell(self, G5_[1][1], G5_[1][1], 1, 0, 1, 0, color_from=HL_COLOR_1, color_to=HL_COLOR_2, rt=0.2)
        add_cell(self, G5_[1][1], G5_[1][1], 2, 0, 2, 0, color_from=HL_COLOR_1, color_to=HL_COLOR_2, rt=0.2)
        add_cell(self, G5_[1][2], G5_[1][1], 1, 0, 1, 0, color_from=HL_COLOR_1, color_to=HL_COLOR_2, rt=0.2)
        add_cell(self, G5_[1][2], G5_[1][1], 2, 0, 2, 0, color_from=HL_COLOR_1, color_to=HL_COLOR_2, rt=0.2)
        add_cell(self, G5_[1][2], G5_[1][1], 3, 0, 3, 0, color_from=HL_COLOR_1, color_to=HL_COLOR_2, rt=0.2)
        self.wait(2)

        show_subtitle(self, "这样不断递推，我们可以将任意L表示为B1—B5的叠加。", "加上翻转后，得到完整的矩阵。")
        for k in range(rows):
            for y in range(cols):
                grid = G5_[k][y]
                row_l = MAT5B[k+1][y]
                row_b = MAT5B[k][y] if k + 1 < len(MAT5B) else []
                w = min(cols, len(row_l), len(grid["lgt"][0]))
                for x in range(w):
                    if row_l[x] and not grid["lgt"][0][x]:
                        toggle_lgt(self, grid, x, 0, rt=0.01)
                    if x < len(row_b) and row_b[x] and not grid["btn"][0][x]:
                        toggle_btn(self, grid, x, 0, rt=0.01)
                gridY = G5Y_[k][y]
                val_btn = MAT5Y[k][y] if k < len(MAT5Y) else 0
                val_lgt = MAT5Y[k+1][y] if k+1 < len(MAT5Y) else 0
                if bool(val_btn) != gridY["btn"][0][0]:
                    toggle_btn(self, gridY, 0, 0, rt=0.01)
                if bool(val_lgt) != gridY["lgt"][0][0]:
                    toggle_lgt(self, gridY, 0, 0, rt=0.01)
        self.wait(6)
        del_top_labels(self, top_objs)
        del_top_labels(self, topy_objs)
        del_left_labels(self, left_objs)

#——————————————————————

        show_subtitle(self, "现在，如果我们把序号1—25用坐标x,y表示，", "则按钮和灯可写为以上公式。让我们以L7(2)=L(2,2,2)为例。")
        LAT1_1 = show_latex(self, "<cL>L(n,x,y)=<cB>B(n,x,y-1)⊕B(n,x,y)⊕B(n,x,y+1)⊕B(n-1,x,y)", 0, 2.0)
        sz=SZ_SMALL
        top_objs = [[None] * cols for _ in range(rows)]
        topy_objs = [[None] * cols for _ in range(rows)]
        left_objs = [[None] * cols for _ in range(rows)]
        for k in range(rows):
            for y in range(cols):
                mx = (y*2-cols)*(1+sz)+1
                my = -k*sz
                mx = (y*2-cols)*(1+sz)+1+sz*(cols+3)/2
                if k == 0: top_objs[k][y] = add_top_labels(self, G5_[k][y], ["x1","x2","x3","x4","x5"], rt=0.01)
                if k == 0: topy_objs[k][y] = add_top_labels(self, G5Y_[k][y], [f"y{y+1}"], rt=0.01)
                left_objs[k][y] = add_left_labels(self, G5_[k][y], [f"n{k+1}"], rt=0.01)
        hl_cells(self, [G5_[1][0]], indices=[(1, 0)])
        hl_cells(self, [G5_[1][1]], indices=[(1, 0)])
        hl_cells(self, [G5_[1][2]], indices=[(1, 0)])
        hl_cells(self, [G5_[0][1]], indices=[(1, 0)])
        self.wait(9)
        del_cells(self, [G5_[1][0]], indices=[(1, 0)])
        del_cells(self, [G5_[1][1]], indices=[(1, 0)])
        del_cells(self, [G5_[1][2]], indices=[(1, 0)])
        del_cells(self, [G5_[0][1]], indices=[(1, 0)])

        show_subtitle(self, "这里，我们的矩阵同时满足另一个性质，", "让我们称之为十字偶校验约束。")
        LAT0_1 = show_latex(self, "<cH2>B(n,x-1,y)⊕B(n,x+1,y)⊕B(n,x,y-1)⊕B(n,x,y+1)=0", 0, 2.5)
        hl_cells(self, [G5_[1][0]], indices=[(1, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][2]], indices=[(1, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][1]], indices=[(0, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][1]], indices=[(2, 0)], color=HL_COLOR_2)
        self.wait(5)

        show_subtitle(self, "某个元素的左右两个矩阵的对应位置的元素，", "和元素所在矩阵左右两个元素的叠加后为零。")
        LAT0_2 = show_latex(self, "<cH2>B(n,x-1,y)⊕B(n,x+1,y)=B(n,x,y-1)⊕B(n,x,y+1)", 0, 2.5, show=False)
        trans_latex(self, LAT0_1, LAT0_2)
        self.wait(7)
        show_subtitle(self, "这也就是上集视频中《优化生成矩阵》章节中的性质，", "之后会给出证明。")
        self.wait(6)
        del_cells(self, [G5_[1][0]], indices=[(1, 0)])
        del_cells(self, [G5_[1][2]], indices=[(1, 0)])
        del_cells(self, [G5_[1][1]], indices=[(0, 0)])
        del_cells(self, [G5_[1][1]], indices=[(2, 0)])

        show_subtitle(self, "通过这个性质，递推公式可化为只根据当前矩阵的元素来叠加，", "无需依赖于左右矩阵。")
        hl_cells(self, [G5_[1][0]], indices=[(1, 0)])
        hl_cells(self, [G5_[1][1]], indices=[(1, 0)])
        hl_cells(self, [G5_[1][2]], indices=[(1, 0)])
        hl_cells(self, [G5_[0][1]], indices=[(1, 0)])
        LAT1_2 = show_latex(self, "<cL>L(n,x,y)=<cB>B(n,x-1,y)⊕B(n,x,y)⊕B(n,x+1,y)⊕B(n-1,x,y)", 0, 2.0, show=False)
        trans_latex(self, LAT1_1, LAT1_2)
        self.wait(1)
        hl_cells(self, [G5_[1][0]], indices=[(1, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][2]], indices=[(1, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][1]], indices=[(0, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][1]], indices=[(2, 0)], color=HL_COLOR_2)
        self.wait(1)
        del_cells(self, [G5_[1][0]], indices=[(1, 0)])
        del_cells(self, [G5_[1][2]], indices=[(1, 0)])
        hl_cells(self, [G5_[1][1]], indices=[(0, 0)])
        hl_cells(self, [G5_[1][1]], indices=[(2, 0)])
        self.wait(2)

        show_subtitle(self, "因此，我们可以在公式中去除y。", "于是，灯可以表示为当前矩阵的上左中右的按钮的叠加。")
        LAT1_3 = show_latex(self, "<cL>L(n,x)=<cB>B(n,x-1)⊕B(n,x)⊕B(n,x+1)⊕B(n-1,x)", 0, 2.0, show=False)
        trans_latex(self, LAT1_2, LAT1_3)
        self.wait(8)

        show_subtitle(self, "又因为，后一行的按钮是前一行灯的翻转，", "而后一行的灯是上左中右的灯的翻转的叠加。")
        LAT1_4 = show_latex(self, "<cB>B(n+1,x)=<cL>¬L(n,x)=<cB>¬(B(n,x-1)⊕B(n,x)⊕B(n,x+1)⊕B(n-1,x))", 0, 2.0, show=False)
        trans_latex(self, LAT1_3, LAT1_4)
        self.wait(4)
        LAT2_1 = show_latex(self, "<cL>L(n+1,x)=<cL>¬L(n,x-1)⊕¬L(n,x)⊕¬L(n,x+1)⊕¬L(n-1,x)", 0, 1.5)
        self.wait(4)

        show_subtitle(self, "因此，如果把翻转¬提取出来，便有了一开始的推导公式。")
        self.wait(5.5)
        show_subtitle(self, "也就是，按钮是前一行的左中右的按钮和上上行的按钮的叠加。", "以及，灯是前一行的左中右的按钮和上上行的灯的叠加。")
        LAT1_5 = show_latex(self, "<cB>B(n,x)=<cB>B(n-1,x-1)⊕B(n-1,x)⊕B(n-1,x+1)⊕B(n-2,x)", 0, 2.0, show=False)
        trans_latex(self, LAT1_4, LAT1_5)
        self.wait(4.5)
        LAT2_2 = show_latex(self, "<cL>L(n,x)=<cL>L(n-1,x-1)⊕L(n-1,x)⊕L(n-1,x+1)⊕L(n-2,x)", 0, 1.5, show=False)
        trans_latex(self, LAT2_1, LAT2_2)
        self.wait(4)
        del_cells(self, [G5_[1][1]], indices=[(0, 0)])
        del_cells(self, [G5_[1][1]], indices=[(1, 0)])
        del_cells(self, [G5_[1][1]], indices=[(2, 0)])
        del_cells(self, [G5_[0][1]], indices=[(1, 0)])

        show_subtitle(self, "可以注意到，按钮和灯的递推公式具有相同的形式，", "这是因为前一行灯就是后一行按钮。")
        self.wait(8.5)
        show_subtitle(self, "因为最终需要推导的是灯，因此灯是从按钮的第一行推导5行。", "因为最后一次推导的是灯，因此按钮也是5行。")
        self.wait(10)
        del_latex(self, [LAT0_2, LAT2_2]);

        show_subtitle(self, "对于翻转的情况，则可以单独列出来，以类似的方法推导，写成公式Y。")
        LAT3 = show_latex(self, "<cH2>Y(n,y)=<cH2>¬(Y(n-1,y-1)⊕Y(n-1,y)⊕Y(n-1,y+1)⊕Y(n-2,y))", 0, 1.5)
        hl_cells(self, [G5Y_[0][1]], indices=[(0, 0)])
        hl_cells(self, [G5Y_[1][0]], indices=[(0, 0)])
        hl_cells(self, [G5Y_[1][1]], indices=[(0, 0)])
        hl_cells(self, [G5Y_[1][2]], indices=[(0, 0)])
        self.wait(5)
        show_subtitle(self, "即后一行的翻转是前一行左中右和上上行叠加后的翻转。")
        self.wait(6)

        show_subtitle(self, "可以注意到，这里的公式Y和公式B的推导公式是类似的。", "只不过，Y是从零向量开始推导的，并且不能省略翻转符号¬。")
        self.wait(11.5)
        show_subtitle(self, "1. 使用零向量：第一次翻转发生在从一到二行的推导过程中，", "在此之前没有发生过翻转，因此Y的第一行是全零。")
        hl_cells(self, [G5Y_[0][0]], indices=[(0, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5Y_[0][1]], indices=[(0, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5Y_[0][2]], indices=[(0, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5Y_[0][3]], indices=[(0, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5Y_[0][4]], indices=[(0, 0)], color=HL_COLOR_2)
        self.wait(10)
        show_subtitle(self, "2. 翻转符号¬必须存在：每次推导都需要翻转，因此不可省略。", "而前者将这个翻转取出来了，因此不用翻转符号¬。")
        self.wait(12)
        show_subtitle(self, "3. 不使用x而使用y：翻转是前面所有按钮的翻转叠加后提取出来的，", "代表的是灯的翻转，而不是某个按钮的翻转。")
        self.wait(8)
        del_cells(self, [G5Y_[0][0]], indices=[(0, 0)])
        del_cells(self, [G5Y_[0][1]], indices=[(0, 0)])
        del_cells(self, [G5Y_[0][2]], indices=[(0, 0)])
        del_cells(self, [G5Y_[0][3]], indices=[(0, 0)])
        del_cells(self, [G5Y_[0][4]], indices=[(0, 0)])
        del_cells(self, [G5Y_[0][1]], indices=[(0, 0)])
        del_cells(self, [G5Y_[1][0]], indices=[(0, 0)])
        del_cells(self, [G5Y_[1][1]], indices=[(0, 0)])
        del_cells(self, [G5Y_[1][2]], indices=[(0, 0)])
        del_grids(self, [G5_, G5Y_], kp_bd=True) 

        sz=SZ_SMALL
        cols, rows = 5, 5
        G5__ = [None] * cols
        G5Y__ = [None] * cols
        my = -((rows - 1) / 2) * sz
        for y in range(cols):
            mx = (y * 2 - cols) * (1 + sz) + 1
            G5__[y] = make_grid(self, w=cols, h=rows, lgt_x=mx, btn_x=mx, lgt_y=my, btn_y=my, sz=SZ_SMALL, mat=[[0] * cols for _ in range(rows)], mat_l=[[0] * cols for _ in range(rows)], show=True, rt=0.01)
            mx = (y * 2 - cols) * (1 + sz) + 1 + sz * (cols + 3) / 2
            G5Y__[y] = make_grid(self, w=1, h=rows, lgt_x=mx, btn_x=mx, lgt_y=my, btn_y=my, sz=SZ_SMALL, mat=[[0] for _ in range(rows)], mat_l=[[0] for _ in range(rows)], show=True, rt=0.01)
        self.wait(2)

#——————————————————————

        show_subtitle(self, "事实上，按钮矩阵也可以用另一种更直观的方法推得。")
        self.wait(5.5)
        show_subtitle(self, "首先，在第一个矩阵中，我们点击第一行第一个按钮。", "然后，点击第二行的按钮，尽量消去第一行的灯。")
        apply_mat(self, G5__[0], [MAT5B[0][0][:]], y0=0, rt=0.8)
        self.wait(3)
        apply_mat(self, G5__[0], [MAT5B[1][0][:]], y0=1, rt=0.8)
        self.wait(4)
        show_subtitle(self, "接着按第三行按钮，消去第二行的灯。", "不断递推，直到最后一行。")
        for k in range(2, 5):
            apply_mat(self, G5__[0], [MAT5B[k][0][:]], y0=k, rt=0.8)
        self.wait(2)
        show_subtitle(self, "最终，最后一行按钮和灯的状态，和前面推得的矩阵是一样的。")
        bd = hl_bd(self, G5_[4][0])
        self.wait(6)
        del_bd(self, bd)

        show_subtitle(self, "同样，在第二个矩阵点击第一行第二个按钮，然后递推，", "也可以得到第二个矩阵最后一行按钮和灯的状态。")
        for k in range(rows):
            apply_mat(self, G5__[1], [MAT5B[k][1][:]], y0=k)
        bd = hl_bd(self, G5_[4][1])
        self.wait(6)
        del_bd(self, bd)

        show_subtitle(self, "通过这个方法，我们可以得到所有矩阵最后一行的状态。")
        for y in range(2, 5):
            for k in range(rows):
                apply_mat(self, G5__[y], [MAT5B[k][y][:]], y0=k, rt=0.15)
        self.wait(2)

        show_subtitle(self, "另外，翻转向量也可以用相似的方法推得。")
        self.wait(4.5)

        show_subtitle(self, "我们把所有灯全部点亮，然后用刚才的方法尝试把所有灯消去，", "同样可以得到翻转向量最后一行的状态。")
        for y in range(rows):
            set_all_lights(self, G5Y__[y])
        self.wait(1)
        for k in range(rows):
            for y in range(rows):
                if MAT5Y[k][y] == 1:
                    press(self, G5Y__[y], 0, k, wait=0.0, include_center=True)
                    clear_all_bd(G5Y__[y])
                    if y - 1 >= 0:
                        press_lgt(G5Y__[y - 1], 0, k, scene=self, rt=0.01, only_center=True)
                        clear_all_bd(G5Y__[y - 1])
                    if y + 1 < rows:
                        press_lgt(G5Y__[y + 1], 0, k, scene=self, rt=0.01, only_center=True)
                        clear_all_bd(G5Y__[y + 1])
        self.wait(2)

        show_subtitle(self, "我们把这种方法称作余数矩阵法，和首行叠加法的原理本质上是相同的，", "有兴趣的小伙伴可以自行证明。")
        self.wait(10)
        del_latex(self, [LAT1_5, LAT3]);
        del_top_labels(self, top_objs)
        del_top_labels(self, topy_objs)
        del_left_labels(self, left_objs)
        del_grids(self, [G5_, G5Y_]) 
        del_grids(self, [G5__, G5Y__]) 

#——————————————————————

        show_title(self, "优化生成矩阵（续上集）")
        show_subtitle(self, "在《优化生成矩阵》章节中，我们将矩阵的行重排。", "其实是调换了n和y的位置，使原来从左到右的第y个矩阵变为了第n个矩阵。")
        sz=SZ_SMALL
        cols, rows = 5, 5
        G5_ = [[None] * cols for _ in range(rows)]
        G5Y_ = [[None] * cols for _ in range(rows)]
        for k in range(rows):
            for y in range(cols):
                mx = (y*2-cols)*(1+sz)+1
                my = -k*sz
                G5_[k][y] = make_grid(self, w=cols, h=1, lgt_x=mx, btn_x=mx, lgt_y=my, btn_y=my, sz=SZ_SMALL, mat=[MAT5B[k][y][:]], mat_l=[MAT5B[k+1][y][:]], show=True, rt=0.01)
                mx = (y*2-cols)*(1+sz)+1+sz*(cols+3)/2
                G5Y_[k][y] = make_grid(self, w=1, h=1, lgt_x=mx, btn_x=mx, lgt_y=my, btn_y=my, sz=SZ_SMALL, mat=[[MAT5Y[k][y]]], mat_l=[[MAT5Y[k+1][y]]],show=True, rt=0.01)
        for k in range(rows):
            for y in range(cols):
                if (k > y):
                    swap_grid(self, G5_[k][y], G5_[y][k], G5Y_[k][y], G5Y_[y][k])
        top_objs = [[None] * cols for _ in range(rows)]
        topy_objs = [[None] * cols for _ in range(rows)]
        left_objs = [[None] * cols for _ in range(rows)]
        for k in range(rows):
            for y in range(cols):
                if k == 0: top_objs[k][y] = add_top_labels(self, G5_[k][y], ["x1","x2","x3","x4","x5"], rt=0.01)
                if k == 0: topy_objs[k][y] = add_top_labels(self, G5Y_[k][y], [f"n{y+1}"], rt=0.01)
                left_objs[k][y] = add_left_labels(self, G5_[k][y], [f"y{k+1}"], rt=0.01)
        self.wait(2)

        show_subtitle(self, "这n个矩阵都满足十字偶校验约束，即上下左右四个格子叠加为零，", "因此这里的公式省去了n。")
        LAT1_1 = show_latex(self, "<cH2>B(x-1,y)⊕B(x+1,y)⊕B(x,y-1)⊕B(x,y+1)=0", 0, 1.5)
        self.wait(9)

        show_subtitle(self, "这里和之前的情况是一样的，", "只不过n和y调换了，因此位置发生了变化。")
        hl_cells(self, [G5_[0][2]], indices=[(1, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][2]], indices=[(0, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][2]], indices=[(2, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[2][2]], indices=[(1, 0)], color=HL_COLOR_2)
        self.wait(6)

        show_subtitle(self, "这是一个十分重要的性质。", "使用这个性质，可以由第一个灯直接推导后面的灯。")
        self.wait(7)
        show_subtitle(self, "在之后的O(n²)算法中，", "其本质也是用这个性质进行的优化。")
        self.wait(6.5)
        show_subtitle(self, "下面让我们用数学归纳法，证明这个性质。")
        self.wait(4.5)

        show_subtitle(self, "由于右边的按钮矩阵就是左边的灯矩阵，", "为了方便，我们就只看按钮矩阵。")
        set_all_lights(self, G5_, on=False)
        set_all_lights(self, G5Y_, on=False)
        self.wait(7)

        show_subtitle(self, "首先，我们假定前两个矩阵B(n-1)和B(n-2)满足这个性质，", "现在来证明B(n)也满足这个性质。")
        LAT1_2 = show_latex(self, "<cH2>B(n,x-1,y)⊕B(n,x+1,y)⊕B(n,x,y-1)⊕B(n,x,y+1)", 0, 1.5, show=False)
        trans_latex(self, LAT1_1, LAT1_2)
        bd = hl_bd(self, [row[2] for row in G5_])
        self.wait(9)

        show_subtitle(self, "将刚才的矩阵递推关系加上参数y并重写。")
        LAT2_1 = show_latex(self, "<cB>B(n,x,y)=B(n-1,x-1,y)⊕B(n-1,x,y)⊕B(n-1,x+1,y)⊕B(n-2,x,y)", 0, 1.0)
        hl_cells(self, [G5_[0][0]], indices=[(1, 0)], color=HL_COLOR_1)
        hl_cells(self, [G5_[0][1]], indices=[(0, 0)], color=HL_COLOR_1)
        hl_cells(self, [G5_[0][1]], indices=[(1, 0)], color=HL_COLOR_1)
        hl_cells(self, [G5_[0][1]], indices=[(2, 0)], color=HL_COLOR_1)
        hl_cells(self, [G5_[0][2]], indices=[(1, 0)], color=HL_COLOR_1)
        self.wait(3)

        show_subtitle(self, "对于B(n)，我们将式子竖着写成四项，", "然后将递推关系代入这个式子。")
        LAT1_3 = show_latex(self, "<cH2>B(n,x-1,y)⊕<br><cH2>B(n,x+1,y)⊕<br><cH2>B(n,x,y-1)⊕<br><cH2>B(n,x,y+1)", 0, 2.0, show=False, font_size=FONT_SIZE_SMALL)
        trans_latex(self, LAT1_2, LAT1_3)
        self.wait(2)
        LAT1_4 = show_latex(self,
            "<cH2>(B(n-1,x-1-1,y)⊕B(n-1,x-1+1,y)⊕B(n-1,x-1,y-1)⊕B(n-1,x-1,y+1))⊕<br>"
            "<cH2>(B(n-1,x-1,y)⊕B(n-1,x+1,y)⊕B(n-1,x,y-1)⊕B(n-1,x,y+1))⊕<br>"
            "<cH2>(B(n-1,x+1-1,y)⊕B(n-1,x+1+1,y)⊕B(n-1,x+1,y-1)⊕B(n-1,x+1,y+1))⊕<br>"
            "<cH2>(B(n-2,x-1,y)⊕B(n-2,x+1,y)⊕B(n-2,x,y-1)⊕B(n-2,x,y+1))",
            0, 2.0, show=False, font_size=FONT_SIZE_SMALL)
        trans_latex(self, LAT1_3, LAT1_4)
        self.wait(3)

        show_subtitle(self, "代入后的式子包含16项。现在重新排列项目顺序，", "将y和n调换，类似《优化生成矩阵》章节中的调换操作。")
        LAT1_5 = show_latex(self,
            "<cH2>(B(n-1,x-1-1,y)⊕B(n-1,x-1,y)⊕B(n-1,x+1-1,y)⊕B(n-2,x-1,y))⊕<br>"
            "<cH2>(B(n-1,x-1+1,y)⊕B(n-1,x+1,y)⊕B(n-1,x+1+1,y)⊕B(n-2,x+1,y))⊕<br>"
            "<cH2>(B(n-1,x-1,y-1)⊕B(n-1,x,y-1)⊕B(n-1,x+1,y-1)⊕B(n-2,x,y-1))⊕<br>"
            "<cH2>(B(n-1,x-1,y+1)⊕B(n-1,x,y+1)⊕B(n-1,x+1,y+1)⊕B(n-2,x,y+1))",
            0, 2.0, show=False, font_size=FONT_SIZE_SMALL)
        trans_latex(self, LAT1_4, LAT1_5)
        hl_cells(self, [G5_[0][0]], indices=[(1, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][0]], indices=[(0, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][0]], indices=[(2, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[2][0]], indices=[(1, 0)], color=HL_COLOR_2)
        del_cells(self, [G5_[0][0]], indices=[(1, 0)])
        del_cells(self, [G5_[1][0]], indices=[(0, 0)])
        del_cells(self, [G5_[1][0]], indices=[(2, 0)])
        del_cells(self, [G5_[2][0]], indices=[(1, 0)])
        hl_cells(self, [G5_[0][1]], indices=[(0, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][1]], indices=[(1, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[2][1]], indices=[(0, 0)], color=HL_COLOR_2)
        del_cells(self, [G5_[0][1]], indices=[(0, 0)])
        del_cells(self, [G5_[1][1]], indices=[(1, 0)])
        del_cells(self, [G5_[2][1]], indices=[(0, 0)])
        hl_cells(self, [G5_[0][1]], indices=[(1, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][1]], indices=[(0, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][1]], indices=[(2, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[2][1]], indices=[(1, 0)], color=HL_COLOR_2)
        del_cells(self, [G5_[0][1]], indices=[(1, 0)])
        del_cells(self, [G5_[1][1]], indices=[(0, 0)])
        del_cells(self, [G5_[1][1]], indices=[(2, 0)])
        del_cells(self, [G5_[2][1]], indices=[(1, 0)])
        hl_cells(self, [G5_[0][1]], indices=[(2, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][1]], indices=[(1, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][1]], indices=[(3, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[2][1]], indices=[(2, 0)], color=HL_COLOR_2)
        del_cells(self, [G5_[0][1]], indices=[(2, 0)])
        del_cells(self, [G5_[1][1]], indices=[(1, 0)])
        del_cells(self, [G5_[1][1]], indices=[(3, 0)])
        del_cells(self, [G5_[2][1]], indices=[(2, 0)])
        hl_cells(self, [G5_[0][2]], indices=[(1, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][2]], indices=[(0, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][2]], indices=[(2, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[2][2]], indices=[(1, 0)], color=HL_COLOR_2)

        show_subtitle(self, "不难发现，这四项属于B(n-1)或B(n-2)，", "并且元素之间的关系满足十字偶校验约束，因此整个式子化为了零。")
        LAT1_6 = show_latex(self, "<cH2>0⊕<br><cH2>0⊕<br><cH2>0⊕<br><cH2>0", 0, 2.0, show=False, font_size=FONT_SIZE_SMALL)
        trans_latex(self, LAT1_5, LAT1_6)
        self.wait(2)
        LAT1_7 = show_latex(self, "<cH2>0⊕0⊕0⊕0", 0, 1.5, show=False)
        trans_latex(self, LAT1_6, LAT1_7)
        self.wait(3)
        LAT1_8 = show_latex(self, "<cH2>B(n,x-1,y)⊕B(n,x+1,y)⊕B(n,x,y-1)⊕B(n,x,y+1)=0", 0, 1.5, show=False)
        trans_latex(self, LAT1_7, LAT1_8)
        self.wait(5)
        del_cells(self, [G5_[0][2]], indices=[(1, 0)])
        del_cells(self, [G5_[1][2]], indices=[(0, 0)])
        del_cells(self, [G5_[1][2]], indices=[(2, 0)])
        del_cells(self, [G5_[2][2]], indices=[(1, 0)])
        del_bd(self, bd)

#——————————————————————

        show_subtitle(self, "现在，我们只需要证明最左边的两个矩阵也满足这个性质即可。", "第一个矩阵是单位矩阵，显然满足这个性质。")
        bd = hl_bd(self, [row[0] for row in G5_])
        hl_cells(self, [G5_[0][0]], indices=[(1, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][0]], indices=[(0, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][0]], indices=[(2, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[2][0]], indices=[(1, 0)], color=HL_COLOR_2)
        self.wait(7)
        del_cells(self, [G5_[0][0]], indices=[(1, 0)])
        del_cells(self, [G5_[1][0]], indices=[(0, 0)])
        del_cells(self, [G5_[1][0]], indices=[(2, 0)])
        del_cells(self, [G5_[2][0]], indices=[(1, 0)])
        del_bd(self, bd)

        show_subtitle(self, "第二个矩阵可以表示为左边两个矩阵的叠加。", "由于单位矩阵左边没有矩阵，因此相当于叠加了一个零矩阵。")
        bd = hl_bd(self, [row[1] for row in G5_])
        hl_cells(self, [G5_[0][1]], indices=[(1, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][1]], indices=[(0, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[1][1]], indices=[(2, 0)], color=HL_COLOR_2)
        hl_cells(self, [G5_[2][1]], indices=[(1, 0)], color=HL_COLOR_2)
        self.wait(8)

        show_subtitle(self, "由于零矩阵显然满足这个性质，因此第二个矩阵也满足这个性质。")
        self.wait(5)
        del_cells(self, [G5_[0][1]], indices=[(1, 0)])
        del_cells(self, [G5_[1][1]], indices=[(0, 0)])
        del_cells(self, [G5_[1][1]], indices=[(2, 0)])
        del_cells(self, [G5_[2][1]], indices=[(1, 0)])
        del_bd(self, bd)

        show_subtitle(self, "因为B(n)有了这个性质，我们只需要知道B(n)的第一行，", "就能通过公式推导出后续的行，求得完整的矩阵B(n)。")
        mat_0 = [[0] * cols]
        mat_lgt = []
        mat_btn = []
        mat_lgt_y = []
        mat_btn_y = []
        for y in range(cols):
            col_lgt = []
            col_btn = []
            col_lgt_y = []
            col_btn_y = []
            for k in range(rows):
                col_lgt.append([MAT5B[k+1][y][:]])
                col_btn.append([MAT5B[k][y][:]])
                col_lgt_y.append([[MAT5Y[k+1][y]]])
                col_btn_y.append([[MAT5Y[k][y]]])
            mat_lgt.append(col_lgt)
            mat_btn.append(col_btn)
            mat_lgt_y.append(col_lgt_y)
            mat_btn_y.append(col_btn_y)
        set_grid_mats(self, grids=G5_, mat=mat_btn, mat_l=mat_lgt, clear_first=False)
        set_grid_mats(self, grids=G5Y_, mat=mat_btn_y, mat_l=mat_lgt_y, clear_first=False)
        bd = hl_bd(self, [G5_[0][4]])
        self.wait(3)
        del_bd(self, bd)
        bd = hl_bd(self, [row[4] for row in G5_])
        self.wait(7)
        del_latex(self, [LAT1_8, LAT2_1])
        del_bd(self, bd)
        del_top_labels(self, top_objs)
        del_top_labels(self, topy_objs)
        del_left_labels(self, left_objs)
        del_grids(self, [G5_, G5Y_]) 

#——————————————————————

        show_title(self, "首行求逆法")

        show_subtitle(self, "为了实现O(n²)的算法，我们也需要用到类似的方法，", "尽量不去对整个矩阵进行操作，而是通过第一行来求逆或求解。")
        grid_B1 = make_grid(self, 7, 1, mat_l=[MAT7B[7][0]], btn_c=B_COLOR, lgt_c=B_COLOR, btn_y=1.2, lgt_y=1.2)
        topy_obj_B = add_top_labels(self, grid_B1, ["", "", "", "B", "", "", ""], color=B_COLOR)
        self.wait(11)

        show_subtitle(self, "我们以n=7为例。这里的B就是前面提到的按钮矩阵B(n)，", "而y就是翻转向量的最后一行，即B(n)的增广向量。")
        grid_B = make_grid(self, 7, 7, mat_l=MAT7B[7], btn_c=B_COLOR, lgt_c=B_COLOR)
        grid_Y = make_grid(self, 1, 7, mat_l=[[v] for v in MAT7Y[7]], btn_c=Y_COLOR, lgt_c=Y_COLOR, btn_x=2, lgt_x=2)
        topy_obj_Y = add_top_labels(self, grid_Y, ["y"], color=Y_COLOR)
        self.wait(11)

        show_subtitle(self, "我们的目标是：对于Bx=y，在已知B的第一行和y的情况下求x。")
        LAT_B = show_latex(self, "<cB>B<cX>x<cY>=y", 0, 2.0)
        grid_B_row = make_grid(self, 7, 1, lgt_y=3*SZ_DEFAULT, btn_y=3*SZ_DEFAULT, show=False)
        bd_B_row = hl_bd(self, grid_B_row)
        grid_X = make_grid(self, 1, 7, mat_l=[[v] for v in VEC_X7], btn_c=X_COLOR, lgt_c=X_COLOR, btn_x=2.8, lgt_x=2.8)
        topy_obj_X = add_top_labels(self, grid_X, ["x"], color=X_COLOR)
        mul_vec_mat(self, w=7, h=7, mat=MAT7B[7], vec=VEC_X7, mat_color=B_COLOR, vec_color=X_COLOR, res_color=Y_COLOR, mat_label="", vec_label="x", res_label="y")
        del_latex(self, [LAT_B])
        del_bd(self, bd_B_row)
        del_top_labels(self, [topy_obj_B, topy_obj_Y, topy_obj_X])
        del_grids(self, [grid_B, grid_Y, grid_X])

        show_subtitle(self, "如果将n在不同情况下的B的第一行写在一起，矩阵长这样，记为B'。")
        move_grid(self, grid_B1, btn_y=-1.4, lgt_y=-1.4, btn_x=-0.2, lgt_x=-0.2)
        bd_b_row7 = hl_bd(self, grid_B1)
        LAT_B = show_latex(self, LATEX_B, 0, 2.0)
        grid_B = make_grid(self, 8, 8, mat_l=MAT_B, mat_g={"lgt": MAT_MK1, "btn": MAT_MK0}, btn_c=B_COLOR, lgt_c=B_COLOR)
        left_obj = add_left_labels(self, grid_B, list(range(8)))
        bottom_obj = add_bottom_label(self, grid_B, "B'", color=B_COLOR)
        hl_cells(self, [grid_B], indices=[(1,1),(0,2),(1,2),(2,2)])
        hl_cells(self, [grid_B], indices=[(1,3)], color=HL_COLOR_2)
        self.wait(4)

        show_subtitle(self, "注意，这里的B'矩阵不是刚才说的当n确定时的完整的矩阵B，", "而是B(n)的第一行拼接起来的结果。")
        self.wait(9)
        del_cells(self, [grid_B], indices=[(1,1),(0,2),(1,2),(2,2)])
        del_cells(self, [grid_B], indices=[(1,3)])

        show_subtitle(self, "另外，这里从n=0开始一共递推n次，最后一个1不包含在矩阵B的第一行内。", "例如n=7时，第一行为1011011，最后一个1省去。")
        del_bottom_labels(self, bottom_obj)
        grid_B0 = make_grid(self, 8, 8, mat_l=MAT_B, mat_g={"lgt": MAT_MK2, "btn": MAT_MK0}, btn_c=B_COLOR, lgt_c=B_COLOR, show=False)
        bottom_obj = add_bottom_label(self, grid_B0, "B''", color=B_COLOR)
        trans_grid(self,grid_B,grid_B0, keep_from=False);
        self.wait(13)

        show_subtitle(self, "改写后的矩阵记为B''=B'⊕I。")
        self.wait(3)
        del_bd(self, bd_b_row7)
        del_latex(self, [LAT_B])
        del_left_labels(self, left_obj)
        del_bottom_labels(self, bottom_obj)
        del_grids(self, [grid_B0, grid_B1])

        show_subtitle(self, "把Y的第一行写在一起是这样的，记为Y'。")
        LAT_Y = show_latex(self, LATEX_Y, 0, 2.0)
        grid_Y = make_grid(self, 8, 8, mat_l=MAT_Y, mat_g={"lgt": MAT_MK2, "btn": MAT_MK0}, btn_c=Y_COLOR, lgt_c=Y_COLOR)
        left_obj = add_left_labels(self, grid_Y, list(range(8)))
        bottom_obj = add_bottom_label(self, grid_Y, "Y'", color=Y_COLOR)
        self.wait(3)
        del_left_labels(self, left_obj)
        del_bottom_labels(self, bottom_obj)
        del_grids(self, [grid_Y])

        show_subtitle(self, "合并在一起后的Y'有以上递推公式。")
        LAT_Y1 = show_latex(self,
            "<cY>Y0(n,y)=Y0(n-1,y-1)⊕Y0(n-1,y)⊕Y0(n-1,y+1)⊕Y0(n-2,y),y>1;Y'(y,n),y=1<br>"
            "<cY>Y1(n,y)=Y'(n-1,y-1)⊕Y0(n-1,y)<br>"
            "<cY>Y2(n,y)=Y1(n-1,y-1)⊕Y0(n-2,y)<br>"
            "<cY>Y'(n,y)=¬(Y1(n,y-1)⊕Y1(n,y)⊕Y1(n,y+1)⊕Y2(n,y)),y<=n;0,y>n",
            0, 0.5, font_size=FONT_SIZE_SMALL)
        LAT_Y2 = show_latex(self,
            "<cY>Y0(n,y)=Y0(n-1,y-1)⊕Y0(n-1,y)⊕Y0(n-1,y+1)⊕Y0(n-2,y),y>1;Y'(n,y),y=1<br>"
            "<cY>Y'(n,y)=¬(Y'(n-1,y-2)⊕Y'(n-1,y-1)⊕Y'(n-1,y)⊕Y'(n-2,y-2)<br>"
            "<cY>⊕Y0(n-1,y-1)⊕Y0(n-1,y)⊕Y0(n-1,y+1)⊕Y0(n-2,y-1)⊕Y0(n-2,y)),y<=n;0,y>n",
            0, -1.25, font_size=FONT_SIZE_SMALL)
        self.wait(5)
        del_latex(self, [LAT_Y, LAT_Y1, LAT_Y2])

        show_subtitle(self, "为了不对整个矩阵进行操作，我们需要将矩阵B进行分解。", "这里介绍一个非常重要的矩阵H，称为邻接扩散矩阵。")
        LAT_H = show_latex(self, LATEX_H, 0, 2.0)
        ctx = mul_vec_mat_begin(self, mat=MAT_H, vec=VEC_V, mat_color=H_COLOR, vec_color=V_COLOR, res_color=V_COLOR, mat_label="H", vec_label="v", res_label="v'")
        self.wait(10)

        show_subtitle(self, "对于H的每一个元素，如果x和y的差为一时取一，否则取零。", "如果将向量v乘以该矩阵，等同于将向量v的每个元素向左右扩散后叠加。")
        LAT_V = show_latex(self, "<cV>v'(x)=v(x)<cH>H<cV>=v(x-1)⊕v(x+1)", 0, 2.5)
        mul_vec_mat_accumulate(self, ctx)
        self.wait(11)

        show_subtitle(self, "这是因为，矩阵的对应行就是向量每个元素左右扩散的结果。")
        self.wait(4)
        del_latex(self, [LAT_H, LAT_V])
        mul_vec_mat_cleanup(self, ctx)

        show_subtitle(self, "不难发现，《首行叠加法》中的各个矩阵B，可以用H表示为以上公式。")
        LAT_BH = show_latex(self, "<cB>B(n)=B(n-1)<cH>H<cB>⊕B(n-1)⊕B(n-2)", 0, 2.5)
        LAT_BH0 = show_latex(self, "<cB>B(0)=<cI>I<cH>=H⁰", 0, 2.0)
        LAT_BH1 = show_latex(self, "<cB>B(1)=<cI>I<cH>⊕H=<cH>H⁰⊕H¹", 0, 1.5)
        LAT_BH2 = show_latex(self, "<cB>B(2)=B(1)<cH>H<cB>⊕B(1)⊕B(0)=<cH>(H²⊕H¹)⊕(H¹⊕H⁰)⊕H⁰=H²", 0, 1.0)
        self.wait(6)

        show_subtitle(self, "这里，B(0)、B(1)、B(2)分别表示为H的不同次数的叠加。")
        LAT_BH0_ = show_latex(self, "<cB>B(0)=<cH>H⁰", 0, 2.0, show=False)
        LAT_BH1_ = show_latex(self, "<cB>B(1)=<cH>H⁰⊕H¹", 0, 1.5, show=False)
        LAT_BH2_ = show_latex(self, "<cB>B(2)=<cH>H²", 0, 1.0, show=False)
        trans_latex(self, LAT_BH0, LAT_BH0_)
        trans_latex(self, LAT_BH1, LAT_BH1_)
        trans_latex(self, LAT_BH2, LAT_BH2_)
        self.wait(3)
        del_latex(self, [LAT_BH0_, LAT_BH1_, LAT_BH2_])

        show_subtitle(self, "将这些H的系数用多项式c(n,x)表示，则有和矩阵B类似的递推公式。","同时，将系数c写成矩阵的形式，记为C。")
        grid_C = make_grid(self, 8, 8, mat_l=MAT_C, mat_g={"lgt": MAT_MK1, "btn": MAT_MK0}, btn_c=C_COLOR, lgt_c=C_COLOR)
        left_obj = add_left_labels(self, grid_C, list(range(8)))
        bottom_obj = add_bottom_label(self, grid_C, "C", color=C_COLOR)
        LAT_C = show_latex(self, LATEX_C, 0, 2.0)
        hl_cells(self, [grid_C], indices=[(1,1),(0,2),(1,2)])
        hl_cells(self, [grid_C], indices=[(1,3)], color=HL_COLOR_2)
        self.wait(10)

        show_subtitle(self, "注意，这里的乘以H的操作在系数上代表右移而不是左右扩散，", "因此，表达式中只有x-1而没有x+1。")
        self.wait(9)
        del_cells(self, [grid_C], indices=[(1,1),(0,2),(1,2)])
        del_cells(self, [grid_C], indices=[(1,3)])
        del_latex(self, [LAT_BH, LAT_C])
        del_left_labels(self, left_obj)
        del_bottom_labels(self, bottom_obj)
        del_grids(self, [grid_C])

        show_subtitle(self, "现在，如果我们将多个H相乘，也就是Hⁿ。", "将其首行Hⁿ(0)拼接起来，看起来像是这样的。")
        grid_K = make_grid(self, 8, 8, mat_l=MAT_K, mat_g={"lgt": MAT_MK1, "btn": MAT_MK0}, btn_c=K_COLOR, lgt_c=K_COLOR)
        left_obj = add_left_labels(self, grid_K, list(range(8)))
        bottom_obj = add_bottom_label(self, grid_K, "K", color=K_COLOR)
        LAT_K1 = show_latex(self, "<cK>K(n)=K(n-1)<cH>H=Hⁿ(0)", 0, 2.5)
        self.wait(9)

        show_subtitle(self, "我们把这个下三角矩阵记为K，又称Krylov矩阵或扩散基矩阵。", "对于K的第n行，有以上公式。")
        self.wait(10)

        show_subtitle(self, "这里后一行是前一行乘以H，也就是前一行的左右扩散。", "因此对于K的每个元素，有以上递推公式。")
        LAT_K2 = show_latex(self, LATEX_K, 0, 2.0)
        hl_cells(self, [grid_K], indices=[(0,2),(2,2)])
        hl_cells(self, [grid_K], indices=[(1,3)], color=HL_COLOR_2)
        self.wait(9)
        del_cells(self, [grid_K], indices=[(0,2),(2,2)])
        del_cells(self, [grid_K], indices=[(1,3)])
        del_latex(self, [LAT_K1, LAT_K2])
        del_left_labels(self, left_obj)
        del_bottom_labels(self, bottom_obj)
        del_grids(self, [grid_K])

#——————————————————————

        show_subtitle(self, "现在，我们定义多项式p(x)。", "我们的目标是把B拆分成Hⁿ。")
        LAT_P1 = show_latex(self, "<cP>p(x)=p₀x⁰⊕p₁x¹⊕p₂x²…=∑(pᵢxⁱ)", 0, 2.5)
        self.wait(7)
        show_subtitle(self, "将矩阵H代入多项式p(x)，得到p(H)，并用其表示矩阵B。")
        LAT_P2 = show_latex(self, "<cB>B<cP>=p(<cH>H<cP>)=p₀<cH>H⁰<cP>⊕p₁<cH>H¹<cP>⊕p₂<cH>H²<cP>⊕…=∑(pᵢ<cH>Hⁱ<cP>)", 0, 2.0)
        self.wait(6.5)
        show_subtitle(self, "这样，原始求x的问题就转化为了p(H)x=y。")
        LAT_P3 = show_latex(self, "<cB>B<cX>x<cP>=p(<cH>H<cP>)<cX>x<cP>=<cY>y", 0, 1.5)
        self.wait(6)
        show_subtitle(self, "现在，我们需要把多项式p(H)的系数计算出来。", "这个系数构成的向量我们记为p。")
        LAT_P4 = show_latex(self, "<cP>p=(p₀,p₁,p₂,…)", 0, 1.0)
        self.wait(8)
        show_subtitle(self, "为了简化运算，我们只关心矩阵第一行B(0)，记为b。", "根据刚才K的定义，我们可以得到b=Kp。")
        LAT_P5 = show_latex(self,
            "<cB>b<br>"
            "<cB>=B(0)<br>"
            "<cP>=p(<cH>H(0)<cP>)<br>"
            "<cP>=p₀<cH>H⁰(0)<cP>⊕p₁<cH>H¹(0)<cP>⊕p₂<cH>H²(0)<cP>⊕…<br>"
            "<cP>=p₀<cK>K(0)<cP>⊕p₁<cK>K(1)<cP>⊕p₂<cK>K(2)<cP>⊕…<br>"
            "<cP>=<cK>K<cP>p",
            0, -0.5)
        self.wait(1)
        del_latex(self, [LAT_P1, LAT_P2, LAT_P3, LAT_P4])
        LAT_B = show_latex(self, "<cB>b=<cK>K<cP>p", 0, 2.0, show=False)
        trans_latex(self, LAT_P5, LAT_B)
        mul_vec_mat(self, w=7, h=7, mat=MAT_K, vec=VEC_P7, mat_color=K_COLOR, vec_color=P_COLOR, res_color=B_COLOR, mat_label="K", vec_label="p", res_label="b")
        del_latex(self, [LAT_B])

        show_subtitle(self, "为了求得p，我们可以将两边同时乘以K的逆矩阵，", "记为F，又称反Krylov矩阵或解耦矩阵。")
        grid_F = make_grid(self, 8, 8, mat_l=MAT_F, mat_g={"lgt": MAT_MK1, "btn": MAT_MK0}, btn_c=F_COLOR, lgt_c=F_COLOR)
        left_obj = add_left_labels(self, grid_F, list(range(8)))
        bottom_obj = add_bottom_label(self, grid_F, "F", color=F_COLOR)
        hl_cells(self, [grid_F], indices=[(1,1),(0,2)])
        hl_cells(self, [grid_F], indices=[(1,3)], color=HL_COLOR_2)
        self.wait(8)

        show_subtitle(self, "这个矩阵F也是下三角矩阵，并且和矩阵K看上去差不多，不过并不相同。", "事实上，这个矩阵F也满足类似的性质。")
        LAT_K = show_latex(self, LATEX_K, 0, 2.5)
        LAT_F = show_latex(self, LATEX_F, 0, 2.0)
        del_bottom_labels(self, bottom_obj)
        del_cells(self, [grid_F], indices=[(1,1),(0,2)])
        del_cells(self, [grid_F], indices=[(1,3)])
        del_grids(self, [grid_F], kp_bd=True)
        grid_K = make_grid(self, 8, 8, mat_l=MAT_K, mat_g={"lgt": MAT_MK1, "btn": MAT_MK0}, btn_c=K_COLOR, lgt_c=K_COLOR)
        bottom_obj = add_bottom_label(self, grid_K, "K", color=K_COLOR)
        hl_cells(self, [grid_K], indices=[(0,2),(2,2)])
        hl_cells(self, [grid_K], indices=[(1,3)], color=HL_COLOR_2)
        self.wait(2)
        del_bottom_labels(self, bottom_obj)
        del_cells(self, [grid_K], indices=[(0,2),(2,2)])
        del_cells(self, [grid_K], indices=[(1,3)])
        del_grids(self, [grid_K])
        grid_F0 = make_grid(self, 8, 8, mat_l=MAT_F, mat_g={"lgt": MAT_MK1, "btn": MAT_MK0}, btn_c=F_COLOR, lgt_c=F_COLOR, show=False)
        bottom_obj = add_bottom_label(self, grid_F0, "F", color=F_COLOR)
        trans_grid(self, grid_F, grid_F0, keep_from=False)
        hl_cells(self, [grid_F0], indices=[(1,1),(0,2)])
        hl_cells(self, [grid_F0], indices=[(1,3)], color=HL_COLOR_2)
        self.wait(4)

        show_subtitle(self, "使用这两个性质构造的矩阵K和F，可以证明S=KF为单位矩阵I，", "有兴趣的小伙伴可以自己试着证明一下。")
        self.wait(10.5)
        show_subtitle(self, "提示：矩阵S=KF满足十字偶校验约束，也就是满足以上递推公式。")
        LAT_S = show_latex(self, "<cI>S(n,x)=S(n-1,x-1)⊕S(n-1,x+1)⊕S(n-2,x)", 0, -2.5)
        self.wait(6)
        del_cells(self, [grid_F0], indices=[(1,1),(0,2)])
        del_cells(self, [grid_F0], indices=[(1,3)])
        del_latex(self, [LAT_K, LAT_F, LAT_S])
        del_left_labels(self, left_obj)

        show_subtitle(self, "这里说明一下，矩阵F的每行对应多项式f(n,x)，", "也就是上集视频《解的数量》章节中提到的OEIS中的Fibonacci多项式。")
        LAT_F = show_latex(self, "<cF>f(n,x)=x·f(n-1,x)⊕f(n-2,x)", 0, 2.5)
        LAT_F2 = show_latex(self, "<cF>F(n,x)=F(n-1,x-1)⊕F(n-2,x)", 0, 2.0)
        self.wait(10)
        del_bottom_labels(self, bottom_obj)
        del_grids(self, [grid_F0])

        show_subtitle(self, "此外，刚才递推得到的矩阵C对应的多项式c(n,x)，", "等价于《解的数量》章节中提到的f(n,x+1)。")
        LAT_C = show_latex(self, "<cC>c(n,x)=x·c(n-1,x)⊕c(n-1,x)⊕c(n-2,x)", 0, 1.25)
        LAT_C2 = show_latex(self, "<cC>C(n,x)=C(n-1,x-1)⊕C(n-1,x)⊕C(n-2,x)", 0, 0.75)
        LAT_CF = show_latex(self, "<cC>c(n,x)<cF>=f(n,x+1)", 0, 0.0)
        self.wait(9)
        show_subtitle(self, "这个证明也不难，", "可以由F和C的关系求出F和C的递推公式，或者由递推公式反推。")
        self.wait(8.5)
        show_subtitle(self, "同时，B(n)矩阵也可以表示为以上形式。", "这里的H⊕I等价于x+1。")
        LAT_B1 = show_latex(self, "<cB>B(n)=B(n-1)(<cH>H<cB>⊕<cI>I<cB>)⊕B(n-2)", 0, -1.0)
        LAT_B2 = show_latex(self, LATEX_B, 0, -1.5)
        self.wait(7)
        del_latex(self, [LAT_F, LAT_F2, LAT_C, LAT_C2, LAT_CF, LAT_B1 , LAT_B2])

#——————————————————————

        show_subtitle(self, "让我们继续求p。由于F和K互逆，于是我们有：Fb=FKp=p。", "将向量b和矩阵F相乘，我们便求出了p。")
        LAT_P = show_latex(self, LATEX_P, 0, 2.0)
        grid_F0 = make_grid(self, 8, 8, mat_l=MAT_F, mat_g={"lgt": MAT_MK1, "btn": MAT_MK0}, btn_c=F_COLOR, lgt_c=F_COLOR)
        move_grid(self, grid_F0, btn_y=-0.2, lgt_y=-0.2, btn_x=0.2, lgt_x=0.2)
        grid_F2 = make_grid(self, 7, 7, mat_l=MAT_F, mat_g={"lgt": MAT_MK1, "btn": MAT_MK0}, btn_c=F_COLOR, lgt_c=F_COLOR)
        self.wait(10.5)
        del_grids(self, [grid_F0])

        show_subtitle(self, "为了和视频中演示的一致，由于b是竖着的，因此写为p=Fb。", "对于矩阵乘法运算来说，则有P=B''F。这里省去了转置符号。")
        ctx = mul_vec_mat_begin(self, w=7, h=7, mat=MAT_F, vec=VEC_B7, mat_color=F_COLOR, vec_color=B_COLOR, res_color=P_COLOR, mat_label="F", vec_label="b", res_label="p")
        mul_vec_mat_accumulate(self, ctx)
        del_grids(self, [grid_F2])
        grid_P0 = make_grid(self, 7, 1, mat_l=[VEC_P7], btn_y=-2, lgt_y=-2, btn_c=P_COLOR, lgt_c=P_COLOR)
        mul_vec_mat_cleanup(self, ctx)
        move_grid(self, grid_P0, btn_y=-1.4, lgt_y=-1.4, btn_x=-0.2, lgt_x=-0.2)
        self.wait(7)

        show_subtitle(self, "将多项式p(x)写成矩阵的形式，记为P。")
        grid_P = make_grid(self, 8, 8, mat_l=MAT_P, mat_g={"lgt": MAT_MK2, "btn": MAT_MK0}, btn_c=P_COLOR, lgt_c=P_COLOR)
        del_grids(self, [grid_P0])
        left_obj = add_left_labels(self, grid_P, list(range(8)))
        bottom_obj = add_bottom_label(self, grid_P, "P", color=P_COLOR)
        self.wait(5)
        del_left_labels(self, left_obj)
        del_bottom_labels(self, bottom_obj)
        del_grids(self, [grid_P])

        show_subtitle(self, "有了p=Fb之后，后续的计算我们都不需要用到完整的B，", "而只需要B的第一行，即向量b。")
        mul_vec_mat(self, w=7, h=7, mat=MAT_F, vec=VEC_B7, mat_color=F_COLOR, vec_color=B_COLOR, res_color=P_COLOR, mat_label="F", vec_label="b", res_label="p", wait=3.0)
        del_latex(self, [LAT_P])

        show_subtitle(self, "这是因为，问题已经从Bx=y转化为了p(H)x=y。", "因此，在前面说到的生成矩阵，也只需要计算向量b，也就是矩阵B'。")
        sz=SZ_DEFAULT
        cols, n = 7, 7
        rows = n + 1
        G5_ = [[None] for _ in range(rows)]
        top_objs = [[None] for _ in range(rows)]
        left_objs = [[None] for _ in range(rows)]
        start_y = (rows - 1) * sz / 2
        for k in range(rows):
            mx = -sz / 2
            my = start_y - k * sz
            G5_[k][0] = make_grid(self, w=cols, h=1, lgt_x=mx, btn_x=mx, lgt_y=my, btn_y=my, mat=[[0]*cols], mat_l=[MAT7B[k][0][:]], show=True, lgt_c=B_COLOR)
            if k == 0: top_objs[k][0] = add_top_labels(self, G5_[k][0], ["B1","B2","B3","B4","B5","B6","B7"], rt=0.01)
            left_objs[k][0] = add_left_labels(self, G5_[k][0], [f"n{k}"], rt=0.01)
        self.wait(10)
        del_left_labels(self, left_objs)
        del_top_labels(self, top_objs)

        show_subtitle(self, "由于在不同n的情况下计算b的公式是一样的，", "我们可以把n-1情况下算出的b，直接用于计算n的情况。")
        LAT_B2 = show_latex(self, LATEX_B, 0, 2.5)
        LAT_B1 = show_latex(self, "<cB>B'(n,x)=B'(n-1,x-1)⊕B'(n-1,x)⊕B'(n-1,x+1)⊕B'(n-2,x)", 0, 2.0)
        grid_B = make_grid(self, 8, 8, mat_l=MAT_B, mat_g={"lgt": MAT_MK1, "btn": MAT_MK0}, btn_c=B_COLOR, lgt_c=B_COLOR)
        del_grids(self, G5_, rt=0.01)
        left_obj = add_left_labels(self, grid_B, list(range(8)))
        bottom_obj = add_bottom_label(self, grid_B, "B'", color=B_COLOR)
        hl_cells(self, [grid_B], indices=[(1,1),(0,2),(1,2),(2,2)])
        hl_cells(self, [grid_B], indices=[(1,3)], color=HL_COLOR_2)
        self.wait(7)

        show_subtitle(self, "这样，如果我们是从n=0开始计算的，", "我们只需要O(n)的时间复杂度便可求出b。")
        self.wait(6)
        del_latex(self, [LAT_B1, LAT_B2])
        del_cells(self, [grid_B], indices=[(1,1),(0,2),(1,2),(2,2)])
        del_cells(self, [grid_B], indices=[(1,3)])
        del_left_labels(self, left_obj)
        del_bottom_labels(self, bottom_obj)
        del_grids(self, [grid_B])

        show_subtitle(self, "同样，计算K和F也是如此。因为每行之间有递推公式，", "如果从n=0开始计算，也可以在O(n)时间内求出。")
        LAT_K = show_latex(self, LATEX_K, 0, 2.0)
        grid_K = make_grid(self, 8, 8, mat_l=MAT_K, mat_g={"lgt": MAT_MK1, "btn": MAT_MK0}, btn_c=K_COLOR, lgt_c=K_COLOR)
        left_obj = add_left_labels(self, grid_K, list(range(8)))
        bottom_obj = add_bottom_label(self, grid_K, "K", color=K_COLOR)
        hl_cells(self, [grid_K], indices=[(0,2),(2,2)])
        hl_cells(self, [grid_K], indices=[(1,3)], color=HL_COLOR_2)
        self.wait(6)
        del_latex(self, [LAT_K])
        del_cells(self, [grid_K], indices=[(0,2),(2,2)])
        del_cells(self, [grid_K], indices=[(1,3)])
        del_left_labels(self, left_obj)
        del_bottom_labels(self, bottom_obj)
        del_grids(self, [grid_K])
        LAT_F = show_latex(self, LATEX_F, 0, 2.0)
        grid_F = make_grid(self, 8, 8, mat_l=MAT_F, mat_g={"lgt": MAT_MK1, "btn": MAT_MK0}, btn_c=F_COLOR, lgt_c=F_COLOR)
        left_obj = add_left_labels(self, grid_F, list(range(8)))
        bottom_obj = add_bottom_label(self, grid_F, "F", color=F_COLOR)
        hl_cells(self, [grid_F], indices=[(1,1),(0,2)])
        hl_cells(self, [grid_F], indices=[(1,3)], color=HL_COLOR_2)

        show_subtitle(self, "如果需要直接计算特定n，可以用其它方法优化到O(n·log(n))。", "因为这里的算法不涉及这个优化，因此就不展开了。")
        self.wait(9.5)
        del_latex(self, [LAT_F])
        del_cells(self, [grid_F], indices=[(1,1),(0,2)])
        del_cells(self, [grid_F], indices=[(1,3)])
        del_left_labels(self, left_obj)
        del_bottom_labels(self, bottom_obj)

        show_subtitle(self, "为了求出p=Fb，我们需要将向量和矩阵相乘，", "一般情况下，其时间复杂度是O(n²)。")
        move_grid(self, grid_F, btn_y=-0.2, lgt_y=-0.2, btn_x=0.2, lgt_x=0.2)
        grid_F2 = make_grid(self, 7, 7, mat_l=MAT_F, mat_g={"lgt": MAT_MK1, "btn": MAT_MK0}, btn_c=F_COLOR, lgt_c=F_COLOR)
        del_grids(self, [grid_F])
        LAT_P = show_latex(self, LATEX_P, 0, 2.0)
        ctx = mul_vec_mat_begin(self, w=7, h=7, mat=MAT_F, vec=VEC_B7, mat_color=F_COLOR, vec_color=B_COLOR, res_color=P_COLOR, mat_label="F", vec_label="b", res_label="p")
        mul_vec_mat_accumulate(self, ctx)
        self.wait(3)

        show_subtitle(self, "因为矩阵F是有递推规律的，理论上使用FFT等算法，", "可以把乘法优化到O(n·log(n))。")
        self.wait(7)
        del_latex(self, [LAT_P])
        del_grids(self, [grid_F2])
        mul_vec_mat_cleanup(self, ctx)

        show_subtitle(self, "另一方面，这里在计算p的时候，我们将B''的对角线去除了，即P=B''F。", "假如我们保留B''的对角线，则有C=B'F。")
        LAT_P = show_latex(self, "<cP>P=<cB>B''<cF>F", 0, 2.0)
        grid_B = make_grid(self, 8, 8, mat_l=MAT_B, mat_g={"lgt": MAT_MK2, "btn": MAT_MK0}, btn_c=B_COLOR, lgt_c=B_COLOR)
        left_obj = add_left_labels(self, grid_B, list(range(8)))
        bottom_obj = add_bottom_label(self, grid_B, "B''", color=B_COLOR)
        self.wait(5)
        del_latex(self, [LAT_P])
        LAT_C = show_latex(self, "<cC>C=<cB>B'<cF>F", 0, 2.0)
        del_bottom_labels(self, bottom_obj)
        grid_B0 = make_grid(self, 8, 8, mat_l=MAT_B, mat_g={"lgt": MAT_MK1, "btn": MAT_MK0}, btn_c=B_COLOR, lgt_c=B_COLOR, show=False)
        bottom_obj = add_bottom_label(self, grid_B0, "B'", color=B_COLOR)
        trans_grid(self, grid_B, grid_B0, keep_from=False);
        self.wait(5)
        del_latex(self, [LAT_C])
        del_left_labels(self, left_obj)
        del_bottom_labels(self, bottom_obj)
        del_grids(self, [grid_B0])

        show_subtitle(self, "为了证明这一点，我们假定B'F=C'，得出以上递推公式。", "由于C'的递推公式和C是相同的，因此这里的C'就是C，即C'=C=B'F。")
        LAT_C0 = show_latex(self, 
            "<cC>C'(n,x)<br>"
            "<cC>=(<cB>B'<cF>F<cC>)(n,x)<br>"
            "<cC>=∑[<cB>B'(n,i)<cF>F(i,x)<cC>]<br>"
            "<cC>=∑[(<cB>B'(n-1,i-1)<cC>⊕<cB>B'(n-1,i)<cC>⊕<cB>B'(n-1,i+1)<cC>⊕<cB>B'(n-2,i))<cF>F(i,x)<cC>]<br>"
            "<cC>=∑[<cB>B'(n-1,i-1)<cF>F(i,x)<cC>⊕<cB>B'(n-1,i)<cF>F(i,x)<cC>⊕<cB>B'(n-1,i+1)<cF>F(i,x)<cC>⊕<cB>B'(n-2,i)<cF>F(i,x)<cC>]<br>"
            "<cC>=∑[<cB>B'(n-1,i)<cF>F(i+1,x)<cC>⊕<cB>B'(n-1,i)<cF>F(i,x)<cC>⊕<cB>B'(n-1,i)<cF>F(i-1,x)<cC>⊕<cB>B'(n-2,i)<cF>F(i,x)<cC>]<br>"
            "<cC>=∑[<cB>B'(n-1,i)<cF>F(i,x-1)<cC>⊕<cB>B'(n-1,i)<cF>F(i-1,x-1)<cC>⊕<cB>B'(n-1,i)<cF>F(i-2,x)<cC>⊕<cB>B'(n-2,i)<cF>F(i,x)<cC>]<br>"
            "<cC>=∑[<cB>B'(n-1,i)<cF>F(i,x-1)<cC>⊕<cB>B'(n-1,i)(<cF>F(i-1,x-1)<cC>⊕<cF>F(i-2,x))<cC>⊕<cB>B'(n-2,i)<cF>F(i,x)<cC>]<br>"
            "<cC>=∑[<cB>B'(n-1,i)<cF>F(i,x-1)<cC>⊕<cB>B'(n-1,i)<cF>F(i,x)<cC>⊕<cB>B'(n-2,i)<cF>F(i,x)<cC>]<br>"
            "<cC>=C'(n-1,x-1)<cC>⊕C'(n-1,x)<cC>⊕C'(n-2,x)",
             0, 1.0, font_size=FONT_SIZE_SMALL)
        self.wait(7)
        LAT_C = show_latex(self, "<cC>C'(n,x)=C'(n-1,x-1)<cC>⊕C'(n-1,x)<cC>⊕C'(n-2,x)", 0, 1.0, show=False)
        trans_latex(self, LAT_C0, LAT_C)
        self.wait(7)

        show_subtitle(self, "由于C=B'F，我们可以推得P=C⊕F。", "因此，我们可以计算出C和F，叠加后直接求得P，无需使用矩阵乘法。")
        LAT_CF = show_latex(self, "<cP>P=<cB>B''<cF>F<cP>=(<cB>B'<cP>⊕<cI>I<cP>)<cF>F=<cB>B'<cF>F<cP>⊕<cI>I<cF>F<cP>=<cC>C<cP>⊕<cF>F", 0, 0.5)
        self.wait(11.5)

        show_subtitle(self, "同时，由于P=C⊕F，P也可以写成这个递推公式，", "从而无需B，C或F，在O(n)的时间内，由P的递推公式直接推得。")
        LAT_P_ = show_latex(self, "<cP>p(n,x)=p(n-1,x)⊕x·(x⊕1)·p(n-2,x)⊕p(n-3,x)⊕p(n-4,x)", 0, -0.5)
        LAT_P = show_latex(self, "<cP>P(n,x)=P(n-1,x)⊕P(n-2,x-1)⊕P(n-2,x-2)⊕P(n-3,x)⊕P(n-4,x)", 0, -1.0)
        self.wait(12)

        show_subtitle(self, "由于这个证明较长，因此这里就不展示出来了。", "有兴趣的小伙伴可以从C和F的递推公式自行证明。")
        self.wait(8.5)
        del_latex(self, [LAT_C, LAT_CF, LAT_P_, LAT_P])

        show_subtitle(self, "现在，我们已用多种方法求得了p，", "并将原始问题转化为了p(H)x=y，可这又有什么用呢？")
        LAT_Y = show_latex(self, "<cB>B<cX>x<cP>=p(<cH>H<cP>)<cX>x<cP>=<cY>y", 0, 0.0, font_size=FONT_SIZE_LARGE)
        self.wait(10)
        del_latex(self, [LAT_Y])

#——————————————————————

        show_title(self, "扩展欧几里得法")

        show_subtitle(self, "试想一下，如果有一个多项式q(x)，满足q(x)p(x)=1 mod f(x)。", "这里的f(x)就是前面提到的多项式f(n,x)。")
        LAT_Q1 = show_latex(self, "<cQ>q(x)<cP>p(x)<cI>=1 mod <cF>f(x)", 0, 2.5)
        poly_7 = show_poly_mul(self, VEC_P7, VEC_Q7, VEC_F7, VEC_G7, sz=SZ_SMALL_POLY)
        self.wait(3)
        grid_q1 = make_grid(self, 1, 7, mat_l=[[v] for v in VEC_Q7], btn_x=-(13/2.0+2.0)*SZ_SMALL_POLY, lgt_x=-(13/2.0+2.0)*SZ_SMALL_POLY, btn_c=Q_COLOR, lgt_c=Q_COLOR, sz=SZ_SMALL_POLY)
        clear_poly_mul(self, poly_7)

        show_subtitle(self, "那么，将式子两边同时乘以q(H)，便有：x=q(H)y。", "这样，我们就能立即求出x。")
        LAT_Q2 = show_latex(self, "<cX>x=<cQ>q(<cH>H<cQ>)<cP>p(<cH>H<cP>)<cX>x=<cQ>q(<cH>H<cQ>)<cY>y", 0, 2.0)
        grid_q0 = make_grid(self, 7, 1, mat_l=[VEC_Q7], btn_y=(7-1)*SZ_DEFAULT/2, lgt_y=(7-1)*SZ_DEFAULT/2, btn_c=P_COLOR, lgt_c=Q_COLOR, show=False)
        trans_grid(self, grid_q1, grid_q0)
        mul_vec_mat(self, w=7, h=7, mat=MAT_Q7, vec=VEC_Y7, mat_color=Q_COLOR, vec_color=Y_COLOR, res_color=X_COLOR, mat_label="Q'", vec_label="y", res_label="x", wait=5.0)

        show_subtitle(self, "我们把这样的多项式q(x)称之为p(x)的逆多项式。", "那么，如何求出逆多项式q(x)呢？")
        label_q = add_left_labels(self, grid_q0, ["q"], color=Q_COLOR)
        self.wait(8)
        del_left_labels(self, [label_q])
        del_grids(self, [grid_q0])

        dx, dy = 2.5, 0.5
        show_subtitle(self, "我们可以使用扩展欧几里得算法，通过f(x)和p(x)来求q(x)。")
        euc = euclid_create(self, VEC_F7, VEC_P7, VEC_O7, VEC_E7, VEC_G7, VEC_Q7, F_COLOR, P_COLOR, I_COLOR, E_COLOR, G_COLOR, Q_COLOR, dx, dy)
        self.wait(6.5)

        show_subtitle(self, "这里，我们同时定义一个零多项式o(x)和单位多项式e(x)，", "在对f(x)和p(x)操作的同时，对o(x)和e(x)做相同的操作。")
        self.wait(12)
        show_subtitle(self, "类似矩阵求逆，我们的目标是：", "将f(x)变为零多项式，p(x)变为单位多项式。")
        self.wait(8)

        show_subtitle(self, "我们使用辗转相减法，将p(x)右移，使其最高次项和f(x)对齐，", "然后叠加到f(x)上，从而消去f(x)的最高次项。")
        grid_f = euc["grid_f"]
        w = grid_f["params"]["w"]
        hl_cells(self, [grid_f], indices=[(w-1, 0)])
        euclid_ops(self, euc, OPS_7, start=0, end=0)
        self.wait(10.5)
        del_cells(self, [grid_f], indices=[(w-1, 0)], rt=0.2)

        show_subtitle(self, "叠加后，如果f(x)的最高次数仍旧大于等于p(x)，", "则继续右移p(x)并叠加到f(x)上。")
        euclid_ops(self, euc, OPS_7, start=1, end=1)
        self.wait(8)

        show_subtitle(self, "否则，当f(x)的最高次数小于p(x)时，将p(x)和f(x)互换，", "使得f(x)的最高次数始终大于或等于p(x)，让叠加操作可以继续下去。")
        euclid_ops(self, euc, OPS_7, start=2, end=2)
        self.wait(12)

        show_subtitle(self, "重复这样的操作，直到f(x)最终被叠加为零。")
        euclid_ops(self, euc, OPS_7, start=3, rt=0.5)
        self.wait(4)

        show_subtitle(self, "最后，剩下的p(x)为两个多项式的最大公因子，记为g(x)，", "同时，剩下的e(x)为p(x)的逆，也就是q(x)。")
        euclid_done(self, euc)
        self.wait(9)
        grid_e0 = make_grid(self, w=8, h=1, lgt_x= dx, btn_x= 2.5, lgt_y=-0.5, btn_y=-0.5, mat_l=[VEC_Q7], btn_c=Q_COLOR, lgt_c=Q_COLOR, rt=0.01)
        euclid_clear(self, euc)

        show_subtitle(self, "我们将q(x)写成矩阵Q。注意，这里的矩阵Q不是前面的完整逆矩阵Q'，", "而是把多个q(x)拼接起来的结果。")
        move_grid(self, grid_e0, btn_y=-1.4, lgt_y=-1.4)
        grid_Q = make_grid(self, 8, 8, mat_l=MAT_Q, mat_g={"lgt": MAT_MK2, "btn": MAT_MK0}, btn_c=Q_COLOR, lgt_c=Q_COLOR)
        left_obj = add_left_labels(self, grid_Q, list(range(8)))
        bottom_obj = add_bottom_label(self, grid_Q, "Q", color=G_COLOR)
        del_grids(self, [grid_e0])
        self.wait(8)
        del_latex(self, [LAT_Q1, LAT_Q2])
        del_left_labels(self, left_obj)
        del_bottom_labels(self, bottom_obj)
        del_grids(self, [grid_Q])

        show_subtitle(self, "现在，我们已求得q(x)，", "接着，我们可以根据q(H)y的定义，用这个式子来求x。")
        LAT_Q3 = show_latex(self, 
            "<cX>x<br><cQ>=q(<cH>H<cQ>)<cY>y<br>"
            "<cQ>=(q₀<cH>H⁰<cQ>⊕q₁<cH>H¹<cQ>⊕q₂<cH>H²<cQ>⊕…)<cY>y<br>"
            "<cQ>=q₀<cH>H⁰<cY>y<cQ>⊕q₁<cH>H¹<cY>y<cQ>⊕q₂<cH>H²<cY>y<cQ>⊕…<br>"
            "<cQ>=∑qᵢ<cH>Hⁱ<cY>y",
             0, 1.0)
        self.wait(8)

        show_subtitle(self, "这里，我们将y不断乘以矩阵H进行左右扩散，", "再根据q(x)的值进行叠加，从而得到x。")
        LAT_Q4 = show_latex(self, "<cX>x=<cQ>q(<cH>H<cQ>)<cY>y<cX>=∑<cQ>qᵢ<cH>Hⁱ<cY>y", 0, 2.5, show=False)
        trans_latex(self, LAT_Q3, LAT_Q4)
        LAT_Y3 = show_latex(self, "<cY>Y''(n,x)=Y''(n-1,x-1)⊕Y''(n-1,x+1)", 0, 2.0)
        mul_vec_mat(self, w=7, h=7, mat=MAT_Y7, vec=VEC_Q7, mat_color=Y_COLOR, vec_color=Q_COLOR, res_color=X_COLOR, mat_label="Y'", vec_label="q", res_label="x", wait=5.0)
        del_latex(self, LAT_Q4, LAT_Y3)

        show_subtitle(self, "另一方面，由于q(H)就是B的逆矩阵Q'，", "并且可以证明Q'也满足十字偶校验约束。")
        LAT_Q5 = show_latex(self, "<cX>x=<cQ>Q'<cY>y<cQ>", 0, 2.5)
        ctx = mul_vec_mat_begin(self, w=7, h=7, mat=MAT_Q7, vec=VEC_Y7, mat_color=Q_COLOR, vec_color=Y_COLOR, res_color=X_COLOR, mat_label="Q'", vec_label="y", res_label="x")
        self.wait(7.5)

        show_subtitle(self, "因此，我们也可以通过Kq求出逆矩阵Q'的第一行Q'(0)，", "再通过递推公式求得完整的Q'，最后再和y相乘求得x。")
        mul_vec_mat_accumulate(self, ctx)
        self.wait(9)
        show_subtitle(self, "两种方法求得的x是相同的，有兴趣的小伙伴可以自行证明。")
        self.wait(6)

        show_subtitle(self, "不过，整个求解的过程中有一个问题，", "那就是我们假设满足q(x)p(x)=1 mod f(x)的多项式q(x)存在。")
        self.wait(10.5)

        show_subtitle(self, "如果这样的多项式q(x)不存在，我们又当如何呢？")
        self.wait(6)
        mul_vec_mat_cleanup(self, ctx)
        del_latex(self, LAT_Q5)

#——————————————————————

        show_title(self, "不可逆矩阵")

        show_subtitle(self, "在上集视频《解的数量》章节中，我们提到了公式r'(n)。")
        LAT_R = show_latex(self, "<cR>r'(n)=deg(<cG>gcd(<cF>f(n,x)<cG>,<cC>c(n,x)<cG>)<cR>)", 0, 1.0)
        self.wait(5.5)
        show_subtitle(self, "这里，gcd表示最大公因子。", "不难发现，这里的gcd(f,c)就是前面扩展欧几里得算法中的g。")
        LAT_G = show_latex(self, "<cG>g(n,x)=gcd(<cF>f(n,x)<cG>,<cC>c(n,x)<cG>)", 0, 0.5)
        LAT_R2 = show_latex(self, "<cR>r'(n)=deg(<cG>g(n,x)<cR>)", 0, 1.0, show=False)
        trans_latex(self, LAT_R, LAT_R2)
        self.wait(8)
        show_subtitle(self, "同时，由于F=C⊕P，因此gcd(f,c)和gcd(f,p)是相等的。")
        LAT_F = show_latex(self, "<cF>f(x)=<cC>c(x)<cF>⊕<cP>p(x)", 0, 0.0)
        LAT_R3 = show_latex(self, "<cR>r'=deg(<cG>g(x)<cR>)", 0, 1.0, show=False)
        LAT_G2 = show_latex(self, "<cG>g(x)=gcd(<cF>f(x)<cG>,<cC>c(x)<cG>)=gcd(<cF>f(x)<cG>,<cP>p(x)<cG>)", 0, 0.5, show=False)
        trans_latex(self, LAT_R2, LAT_R3)
        trans_latex(self, LAT_G, LAT_G2)
        self.wait(5.5)
        show_subtitle(self, "这里，deg表示最高次数，r'是静默操作数，也就是n-r。", "r'的值决定了解的数量，即2ʳ'。")
        self.wait(10)
        del_latex(self, [LAT_R3, LAT_F])
        LAT_G = show_latex(self, LATEX_G, 0, 2.0, show=False)
        trans_latex(self, LAT_G2, LAT_G)

        show_subtitle(self, "将g(x)写成矩阵的形式，记为G。")
        grid_G = make_grid(self, 8, 8, mat_l=MAT_G, mat_g={"lgt": MAT_MK1, "btn": MAT_MK0}, btn_c=G_COLOR, lgt_c=G_COLOR)
        left_obj = add_left_labels(self, grid_G, list(range(8)))
        bottom_obj = add_bottom_label(self, grid_G, "G", color=G_COLOR)
        hl_cells(self, [grid_G], indices=[(0,0),(0,1),(0,2),(0,3),(4,4),(2,5),(0,6),(0,7)], color=HL_COLOR_1)
        self.wait(4)

        show_subtitle(self, "不难注意到，只有当矩阵B为可逆矩阵时，g(x)=1，", "并且g(x)的最高次数为r'=n-r=0。")
        self.wait(9.5)
        del_cells(self, [grid_G], indices=[(0,0),(0,1),(0,2),(0,3),(4,4),(2,5),(0,6),(0,7)])
        del_latex(self, [LAT_G])
        del_left_labels(self, left_obj)
        del_bottom_labels(self, bottom_obj)
        del_grids(self, [grid_G])

        show_subtitle(self, "例如，当n=5时，", "高斯消元后的B的伪逆矩阵Q'和单位矩阵E'是这样的。")
        LAT_G = show_latex(self, "<cB>B<cQ>Q'<cE>=E'", 0, 2.0)
        grid_B5 = make_grid(self, 5, 5, lgt_x=-3, btn_x=-3, mat_l=MAT_B5, btn_c=B_COLOR, lgt_c=B_COLOR)
        grid_Q5 = make_grid(self, 5, 5, lgt_x=-0, btn_x=-0, mat_l=MAT_Q5, btn_c=Q_COLOR, lgt_c=Q_COLOR)
        grid_E5 = make_grid(self, 5, 5, lgt_x=+3, btn_x=+3, mat_l=MAT_E5, btn_c=E_COLOR, lgt_c=E_COLOR)
        topy_obj_B5 = add_top_labels(self, grid_B5, ["", "", "B", "", ""], color=B_COLOR)
        topy_obj_Q5 = add_top_labels(self, grid_Q5, ["", "", "Q'", "", ""], color=Q_COLOR)
        topy_obj_E5 = add_top_labels(self, grid_E5, ["", "", "E'", "", ""], color=E_COLOR)
        self.wait(7)

        show_subtitle(self, "这里，矩阵B不可逆，其秩为r=3。", "现在，我们以r×r为界，将矩阵分为四个部分。")
        grid_B5_Br = make_grid(self, 3, 3, lgt_x=-3.4, btn_x=-3.4, lgt_y=0.4, btn_y=0.4, mat_l=[[0]*3 for _ in range(3)], btn_c=B_COLOR, lgt_c=B_COLOR, rt=0.01)
        grid_Q5_Qr = make_grid(self, 3, 3, lgt_x=-0.4, btn_x=-0.4, lgt_y=0.4, btn_y=0.4, mat_l=[[0]*3 for _ in range(3)], btn_c=Q_COLOR, lgt_c=Q_COLOR, rt=0.01)
        grid_E5_Ir = make_grid(self, 3, 3, lgt_x=2.6, btn_x=2.6, lgt_y=0.4, btn_y=0.4, mat_l=[[0]*3 for _ in range(3)], btn_c=E_COLOR, lgt_c=E_COLOR, rt=0.01)
        bd_B5_Br = hl_bd(self, grid_B5_Br)
        bd_Q5_Qr = hl_bd(self, grid_Q5_Qr)
        bd_E5_Ir = hl_bd(self, grid_E5_Ir, color=HL_COLOR_2)
        self.wait(9)

        show_subtitle(self, "1. 矩阵B左上角r×r的子矩阵可逆，", "并且和Q'左上角r×r的子矩阵互为逆矩阵。")
        self.wait(8.5)
        del_grids(self, [grid_B5_Br, grid_Q5_Qr, grid_E5_Ir])
        del_bd(self, bd_B5_Br)
        del_bd(self, bd_Q5_Qr)
        del_bd(self, bd_E5_Ir)

        show_subtitle(self, "2. Q'右下角和E'左上角为单位矩阵，", "Q'右上角和E'下方为零矩阵。")
        grid_Q5_I22 = make_grid(self, 2, 2, lgt_x=0.6, btn_x=0.6, lgt_y=-0.6, btn_y=-0.6, mat_l=[[0]*2 for _ in range(2)], btn_c=Q_COLOR, lgt_c=Q_COLOR, rt=0.01)
        grid_E5_I33 = make_grid(self, 3, 3, lgt_x=2.6, btn_x=2.6, lgt_y=0.4, btn_y=0.4, mat_l=[[0]*3 for _ in range(3)], btn_c=E_COLOR, lgt_c=E_COLOR, rt=0.01)
        grid_Q5_Z32 = make_grid(self, 2, 3, lgt_x=0.6, btn_x=0.6, lgt_y=0.4, btn_y=0.4, mat_l=[[0]*2 for _ in range(3)], btn_c=Q_COLOR, lgt_c=Q_COLOR, rt=0.01)
        grid_E5_Z25 = make_grid(self, 5, 2, lgt_x=3.0, btn_x=3.0, lgt_y=-0.6, btn_y=-0.6, mat_l=[[0]*5 for _ in range(2)], btn_c=E_COLOR, lgt_c=E_COLOR, rt=0.01)
        bd_Q5_I22 = hl_bd(self, grid_Q5_I22)
        bd_E5_I33 = hl_bd(self, grid_E5_I33)
        bd_Q5_Z32 = hl_bd(self, grid_Q5_Z32, color=HL_COLOR_2)
        bd_E5_Z25 = hl_bd(self, grid_E5_Z25, color=HL_COLOR_2)
        self.wait(6)
        del_grids(self, [grid_Q5_I22, grid_E5_I33, grid_Q5_Z32, grid_E5_Z25])
        del_bd(self, bd_Q5_Z32)
        del_bd(self, bd_E5_Z25)
        del_bd(self, bd_Q5_I22)
        del_bd(self, bd_E5_I33)

        show_subtitle(self, "3. Q'左下角Wr和E'右上角的静默操作相同，", "并且其值等于Q'左上角乘以B右上角，或者B左下角乘以Q'左上角。")
        grid_B5_U1 = make_grid(self, 3, 2, lgt_x=-3.4, btn_x=-3.4, lgt_y=-0.6, btn_y=-0.6, mat_l=[[0]*3 for _ in range(2)], btn_c=B_COLOR, lgt_c=B_COLOR, rt=0.01)
        grid_B5_U2 = make_grid(self, 2, 3, lgt_x=-2.4, btn_x=-2.4, lgt_y=0.4, btn_y=0.4, mat_l=[[0]*2 for _ in range(3)], btn_c=B_COLOR, lgt_c=B_COLOR, rt=0.01)
        grid_Q5_Qr = make_grid(self, 3, 3, lgt_x=-0.4, btn_x=-0.4, lgt_y=0.4, btn_y=0.4, mat_l=[[0]*3 for _ in range(3)], btn_c=Q_COLOR, lgt_c=Q_COLOR, rt=0.01)
        grid_Q5_Wr = make_grid(self, 3, 2, lgt_x=-0.4, btn_x=-0.4, lgt_y=-0.6, btn_y=-0.6, mat_l=[[0]*3 for _ in range(2)], btn_c=Q_COLOR, lgt_c=Q_COLOR, rt=0.01)
        grid_E5_Wr = make_grid(self, 2, 3, lgt_x=3.6, btn_x=3.6, lgt_y=0.4, btn_y=0.4, mat_l=[[0]*2 for _ in range(3)], btn_c=E_COLOR, lgt_c=E_COLOR, rt=0.01)
        bd_Q5_Wr = hl_bd(self, grid_Q5_Wr)
        bd_E5_Wr = hl_bd(self, grid_E5_Wr)
        bd_B5_U1 = hl_bd(self, grid_B5_U1, color=HL_COLOR_2)
        bd_B5_U2 = hl_bd(self, grid_B5_U2, color=HL_COLOR_2)
        bd_Q5_Qr = hl_bd(self, grid_Q5_Qr, color=HL_COLOR_2)
        self.wait(10)
        del_grids(self, [grid_B5_U1, grid_B5_U2, grid_Q5_Qr, grid_Q5_Wr, grid_E5_Wr])
        del_bd(self, bd_B5_U1)
        del_bd(self, bd_B5_U2)
        del_bd(self, bd_Q5_Qr)
        del_bd(self, bd_Q5_Wr)
        del_bd(self, bd_E5_Wr)

        show_subtitle(self, "这些性质可以通过分块矩阵乘法，结合高斯消元法和矩阵B的对称性得出，", "有兴趣的小伙伴可以自行证明。")
        self.wait(9)
        grid_q4 = make_grid(self, 5, 1, lgt_y=sz*2, btn_y=sz*2, mat_l=[VEC_Q5_2], btn_c=Q_COLOR, lgt_c=Q_COLOR)
        del_latex(self, LAT_G)
        del_top_labels(self, [topy_obj_B5, topy_obj_Q5, topy_obj_E5])
        del_grids(self, [grid_B5, grid_Q5, grid_E5])

        show_subtitle(self, "可以发现，Q'不满足十字偶校验约束，因而无法通过公式递推求得。", "并且使用Q'第一行求得的x也不是原方程的解。")
        grid_q5 = make_grid(scene, 5, 1, lgt_y=sz*2, btn_y=sz*2, mat_l=[VEC_Q5_2], btn_c=Q_COLOR, lgt_c=Q_COLOR, show=False)
        trans_grid(self, grid_q4, grid_q5)
        mul_vec_mat(self, w=5, h=5, mat=MAT_Q5_2, vec=VEC_Y5, mat_color=Q_COLOR, vec_color=Y_COLOR, res_color=X_COLOR, mat_label="Q'", vec_label="y", res_label="x", wait=6.5)

        show_subtitle(self, "如果我们令Q'第一行为q(x)，并且和p(x)相乘，", "由此得到的g(x)不为1，且最高次数为4。")
        grid_q6 = make_grid(self, 1, 5, mat_l=[[v] for v in VEC_Q5_2], btn_x=-(9/2.0+2.0)*sz, lgt_x=-(9/2.0+2.0)*sz, btn_c=Q_COLOR, lgt_c=Q_COLOR, show=False)
        trans_grid(self, grid_q5, grid_q6)
        poly_5 = show_poly_mul(self, VEC_P5, VEC_Q5_2, VEC_F5, VEC_G5_2)
        self.wait(2)
        del_grids(self, [grid_q6])
        clear_poly_mul(self, poly_5)

        show_subtitle(self, "另一方面，如果我们直接使用扩展欧几里得法，", "通过p(x)和f(x)进行求解，得到的g(x)也不为1。")
        dx, dy = 2.5, 0.5
        euc = euclid_create(self, VEC_F5, VEC_P5, VEC_O5, VEC_E5, VEC_G5, VEC_Q5, F_COLOR, P_COLOR, I_COLOR, E_COLOR, G_COLOR, Q_COLOR, dx, dy)
        euclid_ops(self, euc, OPS_5, rt=0.3)
        euclid_done(self, euc)
        grid_q1 = make_grid(self, w=6, h=1, lgt_x=dx, btn_x=dx, lgt_y=-dy, btn_y=-dy, mat_l=[VEC_Q5], btn_c=Q_COLOR, lgt_c=Q_COLOR)
        self.wait(5)
        euclid_clear(self, euc)

        show_subtitle(self, "将求得的q(x)和p(x)相乘，", "得到刚才求得的g(x)，其最高次数为2。")
        grid_q2 = make_grid(self, 1, 5, mat_l=[[v] for v in VEC_Q5], btn_x=-(9/2.0+2.0)*sz, lgt_x=-(9/2.0+2.0)*sz, btn_c=Q_COLOR, lgt_c=Q_COLOR, show=False)
        trans_grid(self, grid_q1, grid_q2)
        poly_5 = show_poly_mul(self, VEC_P5, VEC_Q5, VEC_F5, VEC_G5)
        self.wait(2)
        clear_poly_mul(self, poly_5)

        show_subtitle(self, "这里，我们计算q(H)y，发现求得的x也不是正确的解。")
        grid_q3 = make_grid(scene, 5, 1, lgt_y=sz*2, btn_y=sz*2, mat_l=[VEC_Q5], btn_c=Q_COLOR, lgt_c=Q_COLOR, show=False)
        trans_grid(self, grid_q2, grid_q3)
        mul_vec_mat(self, w=5, h=5, mat=MAT_Q5_1, vec=VEC_Y5, mat_color=Q_COLOR, vec_color=Y_COLOR, res_color=X_COLOR, mat_label="q(H)", vec_label="y", res_label="x", wait=2.0)
        del_grids(self, [grid_q3])

        show_subtitle(self, "两种方法求得的q(x)和g(x)都不相同，", "g(x)都不为1，并且q(H)y也都不是正确的解。")
        grid_p = make_grid(self, w=5, h=1, lgt_x=-dx, btn_x=-dx, lgt_y=dy, btn_y=dy, mat_l=[VEC_P5], btn_c=P_COLOR, lgt_c=P_COLOR)
        grid_q1 = make_grid(self, w=5, h=1, lgt_x=-dx, btn_x=-dx, lgt_y=-dy, btn_y=-dy, mat_l=[VEC_Q5_2], btn_c=Q_COLOR, lgt_c=Q_COLOR)
        grid_q2 = make_grid(self, w=5, h=1, lgt_x=-dx, btn_x=-dx, lgt_y=-dy-sz, btn_y=-dy-sz, mat_l=[VEC_Q5], btn_c=Q_COLOR, lgt_c=Q_COLOR)
        label_p = add_left_labels(self, grid_p, ["p"], dx=sz, color=P_COLOR)
        label_q1 = add_left_labels(self, grid_q1, ["q"], dx=sz, color=Q_COLOR)
        label_q2 = add_left_labels(self, grid_q2, ["q"], dx=sz, color=Q_COLOR)
        grid_f = make_grid(self, w=5, h=1, lgt_x=dx, btn_x=dx, lgt_y=dy, btn_y=dy, mat_l=[VEC_F5], btn_c=F_COLOR, lgt_c=F_COLOR)
        grid_g1 = make_grid(self, w=5, h=1, lgt_x=dx, btn_x=dx, lgt_y=-dy, btn_y=-dy, mat_l=[VEC_G5_2], btn_c=G_COLOR, lgt_c=G_COLOR)
        grid_g2 = make_grid(self, w=5, h=1, lgt_x=dx, btn_x=dx, lgt_y=-dy-sz, btn_y=-dy-sz, mat_l=[VEC_G5], btn_c=G_COLOR, lgt_c=G_COLOR)
        label_f = add_left_labels(self, grid_f, ["f"], dx=sz, color=F_COLOR)
        label_g1 = add_left_labels(self, grid_g1, ["g"], dx=sz, color=G_COLOR)
        label_g2 = add_left_labels(self, grid_g2, ["g"], dx=sz, color=G_COLOR)
        self.wait(7.5)

        show_subtitle(self, "因此，如果g(x)不为1，则q(x)不满足q(x)p(x)=1 mod f(x)。", "或者说，满足q(x)p(x)=1的q(x)不存在。")
        self.wait(12)
        del_left_labels(self, [label_p, label_q1, label_q2, label_f, label_g1, label_g2])
        del_grids(self, [grid_p, grid_q1, grid_q2, grid_f, grid_g1, grid_g2])

        show_subtitle(self, "那么对于不可逆的矩阵B，我们又有什么方法可以求出正确的解呢？")
        LAT_G = show_latex(self, "<cB>B<cQ>Q'<cE>=E'", 0, 2.0)
        grid_B5 = make_grid(self, 5, 5, lgt_x=-3, btn_x=-3, mat_l=MAT_B5, btn_c=B_COLOR, lgt_c=B_COLOR)
        grid_Q5 = make_grid(self, 5, 5, lgt_x=-0, btn_x=-0, mat_l=MAT_Q5, btn_c=Q_COLOR, lgt_c=Q_COLOR)
        grid_E5 = make_grid(self, 5, 5, lgt_x=+3, btn_x=+3, mat_l=MAT_E5, btn_c=E_COLOR, lgt_c=E_COLOR)
        topy_obj_B5 = add_top_labels(self, grid_B5, ["", "", "B", "", ""], color=B_COLOR)
        topy_obj_Q5 = add_top_labels(self, grid_Q5, ["", "", "Q'", "", ""], color=Q_COLOR)
        topy_obj_E5 = add_top_labels(self, grid_E5, ["", "", "E'", "", ""], color=E_COLOR)
        self.wait(5)
        del_latex(self, LAT_G)
        del_top_labels(self, [topy_obj_B5, topy_obj_Q5, topy_obj_E5])
        del_grids(self, [grid_B5, grid_Q5, grid_E5])

#——————————————————————

        show_title(self, "反向叠加法")

        show_subtitle(self, "在刚才的《首行求逆法》中，我们有这些公式。")
        LAT_A1_1 = show_latex(self, "<cQ>q(x)<cP>p(x)<cI>=1 mod <cF>f(x)", 0, 2.0)
        LAT_B1_1 = show_latex(self, "<cP>p(H)<cX>x=<cY>y", 0, -0.0)
        LAT_B2_1 = show_latex(self, "<cX>x=<cQ>q(H)<cY>y", 0, -0.5)
        self.wait(3)

        show_subtitle(self, "现在，我们定义多项式q'(x)，", "满足q'(x)p(x)=g(x) mod f(x)。")
        LAT_A1_2 = show_latex(self, "<cQ>q'(x)<cP>p(x)<cG>=g(x) mod <cF>f(x)", 0, 2.0, show=False)
        trans_latex(self, LAT_A1_1, LAT_A1_2)
        self.wait(7)

        show_subtitle(self, "其中，g(x)也就是刚才提到的最大公因子，", "q'(x)就是刚才求得的q(x)。")
        LAT_A0_1 = show_latex(self, "<cG>g(x)=gcd(<cP>p(x)<cG>,<cF>f(x)<cG>)", 0, 2.5)
        self.wait(8)

        show_subtitle(self, "由于原本求得的x并不是正确的解，", "我们将其重命名为z，即z=q'(H)y。")
        LAT_B1_2 = show_latex(self, "<cP>p(H)<cX>x=<cY>y", 0, -0.0, show=False)
        trans_latex(self, LAT_B1_1, LAT_B1_2)
        LAT_B2_2 = show_latex(self, "<cZ>z=<cQ>q'(H)<cY>y", 0, -0.5, show=False)
        trans_latex(self, LAT_B2_1, LAT_B2_2)
        self.wait(7)

        show_subtitle(self, "同时，我们定义q'(x)的逆多项式p'(x)，", "即q'(x)p'(x)=1 mod f(x)。")
        LAT_A2_1 = show_latex(self, "<cQ>q'(x)<cP>p'(x)<cI>=1 mod <cF>f(x)", 0, 1.5)
        self.wait(9)

        show_subtitle(self, "我们不难推出这些式子。", "为了方便表示，这里将mod f(x)的部分省去了。")
        LAT_A1_3 = show_latex(self, "<cQ>q'(x)<cP>p(x)<cG>=g(x)", 0, 2.0, show=False)
        trans_latex(self, LAT_A1_2, LAT_A1_3)
        LAT_A2_2 = show_latex(self, "<cQ>q'(x)<cP>p'(x)<cI>=1", 0, 1.5, show=False)
        trans_latex(self, LAT_A2_1, LAT_A2_2)
        LAT_C1_1 = show_latex(self, "<cP>p'(x)<cQ>q'(x)<cP>p(x)<cG>=<cP>p'(x)<cG>g(x)", 0, 1.0)
        LAT_C2_1 = show_latex(self, "<cQ>q'(x)=<cQ>q'(x)<cP>p(x)<cQ>q(x)<cG>=g(x)<cQ>q(x)", 0, 0.5)
        LAT_D1_1 = show_latex(self, "<cP>p(H)<cX>x=<cG>g(H)<cP>p'(H)<cX>x=<cP>p'(H)<cZ>z=<cP>p'(H)<cQ>q'(H)<cY>y=y", 0, -1.0)
        LAT_D2_1 = show_latex(self, "<cZ>z=<cQ>q'(H)<cY>y=<cQ>q'(H)<cP>p(H)<cX>x=<cG>g(H)<cX>x", 0, -1.5)
        LAT_D3_1 = show_latex(self, "<cG>g(H)<cY>y=<cQ>q'(H)<cP>p(H)<cY>y=<cG>g(H)<cP>p(H)<cX>x", 0, -2.0)
        self.wait(4)

        show_subtitle(self, "整理后，我们可以得到这些式子。")
        LAT_A1_4 = show_latex(self, "<cG>g(x)=<cQ>q'(x)<cP>p(x)", 0, 2.0, show=False)
        trans_latex(self, LAT_A1_3, LAT_A1_4, rt=0.3)
        LAT_A2_3 = show_latex(self, "<cI>1=<cQ>q'(x)<cP>p'(x)", 0, 1.5, show=False)
        trans_latex(self, LAT_A2_2, LAT_A2_3, rt=0.3)
        LAT_C1_2 = show_latex(self, "<cP>p(x)=p'(x)<cG>g(x)", 0, 1.0, show=False)
        trans_latex(self, LAT_C1_1, LAT_C1_2, rt=0.3)
        LAT_C2_2 = show_latex(self, "<cQ>q'(x)=q(x)<cG>g(x)", 0, 0.5, show=False)
        trans_latex(self, LAT_C2_1, LAT_C2_2, rt=0.3)
        LAT_B1_3 = show_latex(self, "<cY>y=<cP>p(H)<cX>x", 0, -0.0, show=False)
        trans_latex(self, LAT_B1_2, LAT_B1_3, rt=0.3)
        LAT_D1_2 = show_latex(self, "<cY>y=<cP>p'(H)<cZ>z", 0, -1.0, show=False)
        trans_latex(self, LAT_D1_1, LAT_D1_2, rt=0.3)
        LAT_D2_2 = show_latex(self, "<cZ>z=<cG>g(H)<cX>x", 0, -1.5, show=False)
        trans_latex(self, LAT_D2_1, LAT_D2_2, rt=0.3)
        LAT_D3_2 = show_latex(self, "<cQ>q'(H)<cY>y=<cG>g(H)<cX>x", 0, -2.0, show=False)
        trans_latex(self, LAT_D3_1, LAT_D3_2, rt=0.3)
        LAT_B1_4 = show_latex(self, "<cY>y=<cP>p(H)<cX>x=<cP>p'(H)<cZ>z", 0, -0.0, show=False)
        trans_latex(self, LAT_B1_3, LAT_B1_4, rt=0.3)
        LAT_B2_4 = show_latex(self, "<cZ>z=<cQ>q'(H)<cY>y<cZ>=<cG>g(H)<cX>x", 0, -0.5, show=False)
        trans_latex(self, LAT_B2_2, LAT_B2_4, rt=0.3)
        LAT_B2_5 = show_latex(self, "<cZ>z=<cQ>q'(H)<cY>y<cZ>=<cG>g(H)<cX>x", 0, -0.5)
        del_latex(self, [LAT_D1_2, LAT_D2_2, LAT_D3_2])
        self.wait(2)

        show_subtitle(self, "最终，我们得到了z=g(H)x。", "这里，如果g(x)=1，则会有右边这些式子。")
        lat_B2 = hl_objs(self, [LAT_B2_5], width=BD_W_SEL/2)
        LAT_A1_0 = show_latex(self, "<cG>g(x)=<cI>1", 4, 1.75)
        LAT_C1_0 = show_latex(self, "<cQ>q'(x)=q(x)", 4, 1.0)
        LAT_C2_0 = show_latex(self, "<cP>p'(x)=p(x)", 4, 0.5)
        LAT_D2_0 = show_latex(self, "<cZ>z=<cX>x", 4, -0.25)
        self.wait(7)
        del_latex(self, [LAT_A1_0, LAT_C1_0, LAT_C2_0, LAT_D2_0])
        del_latex(self, [LAT_A1_4, LAT_A2_3, LAT_C1_2, LAT_C2_2, LAT_B1_4])
        del_hl_objs(self, lat_B2)

        show_subtitle(self, "前面使用的扩展欧几里得法中，我们已求得q'(x)和g(x)。", "因此，接下来只需要使用g(x)和z即可求得x。")
        LAT_E0 = show_latex(self, "<cQ>q'(x)=<cP>p(x)⁻¹<cI> mod <cF>f(x)", 0, 2.0)
        self.wait(11)

        show_subtitle(self, "前者，我们有公式z=q'(H)y。", "我们不断让y乘以H，然后使用向量乘以矩阵的方法求得z。")
        LAT_E1 = show_latex(self, "<cZ>z=<cQ>q'(H)<cY>y", 0, 1.0, show=False)
        trans_latex(self, LAT_B2_4, LAT_E1)
        self.wait(9.5)

        show_subtitle(self, "现在，我们有公式z=g(H)x。", "由于需要求得的是x，因此不能再使用这个方法来求解。")
        LAT_E2 = show_latex(self, "<cZ>z=<cG>g(H)<cX>x", 0, 0.5, show=False)
        trans_latex(self, LAT_B2_5, LAT_E2)
        self.wait(9)
        del_latex(self, [LAT_A0_1, LAT_E0, LAT_E1])
        LAT_Z = show_latex(self, "<cZ>z=<cG>g(H)<cX>x", 0, 2.5, show=False)
        trans_latex(self, LAT_E2, LAT_Z)

#——————————————————————

        show_subtitle(self, "这次，我们需要用反向叠加法来求x。", "我们以n=5为例。")
        grid_G5 = make_grid(self, 5, 5, mat_l=MAT_D5, lgt_c=G_COLOR)
        label_G5 = add_top_labels(self, grid_G5, ["", "", "g(H)", "", ""], dy=grid_G5["params"]["sz"], color=G_COLOR)
        self.wait(6.5)

        show_subtitle(self, "首先，我们需要使用类似生成矩阵B的方法生成g(H)，", "这里记为矩阵D，其秩与矩阵B相同。")
        LAT_D = show_latex(self, "<cG>g(<cH>H<cG>)=<cD>D", 0, 2.0)
        grid_D5 = make_grid(self, 5, 5, mat_l=MAT_D5, lgt_c=D_COLOR, show=False)
        del_top_labels(self, label_G5)
        trans_grid(self, grid_G5, grid_D5)
        label_D5 = add_top_labels(self, grid_G5, ["", "", "D", "", ""], dy=grid_D5["params"]["sz"], color=D_COLOR)
        self.wait(9.5)
        del_top_labels(self, label_D5)
        del_grids(self, [grid_D5])

        sz=SZ_SMALL
        cols, rows = 5, 5
        show_subtitle(self, "1. 创建n个单位向量，也就是矩阵D的第一行。", "这里和矩阵B相同，一共有n个向量。")
        G5_ = [[None] * cols for _ in range(rows)]
        bd = [[None] * cols for _ in range(rows)]
        for k in range(0, 1):
            for y in range(cols):
                mx = (y*2-cols)*(1+sz)+1
                my = -k*sz
                G5_[k][y] = make_grid(self, w=cols, h=1, lgt_x=mx, btn_x=mx, lgt_y=my, btn_y=my, sz=SZ_SMALL, mat_l=[MAT5D[k][y][:]], show=True, lgt_c=K_COLOR)
        self.wait(7.5)
        show_subtitle(self, "2. 使用矩阵H，将每个矩阵D的第一行扩散到后续的行。")
        for k in range(1, rows):
            for y in range(cols):
                mx = (y*2-cols)*(1+sz)+1
                my = -k*sz
                G5_[k][y] = make_grid(self, w=cols, h=1, lgt_x=mx, btn_x=mx, lgt_y=my, btn_y=my, sz=SZ_SMALL, mat_l=[MAT5D[k][y][:]], show=True, rt=0.1, lgt_c=K_COLOR)
        self.wait(4)
        show_subtitle(self, "3. 根据多项式g(x)，将每个矩阵D的对应行叠加起来，", "叠加完的行共同构成一个新的矩阵D。")
        G5D_ = [None] * cols
        bdD = [None] * cols
        for y in range(cols):
            mx = (y*2-cols)*(1+sz)+1
            my = -(rows+1)*sz
            G5D_[y] = make_grid(self, w=cols, h=1, lgt_x=mx, btn_x=mx, lgt_y=my, btn_y=my, sz=SZ_SMALL, mat_l=[[0] * rows], show=True, lgt_c=D_COLOR, rt=0.1)
        grid_G = make_grid(self, 1, rows, mat_l=[[v] for v in VEC_G5], btn_x=-6.5, lgt_x=-6.5, btn_y=-2*SZ_SMALL, lgt_y=-2*SZ_SMALL, btn_c=G_COLOR, lgt_c=G_COLOR, sz=SZ_SMALL)
        for y in range(cols):
            for k in range(1, 3):
                bd[k][y] = hl_bd(self, G5_[k][y], rt=0.1)
        for y in range(cols):
            for k in range(1, 3):
                add_grid(self, G5_[k][y], G5D_[y], keep_from=True, rt=0.3)
                del_bd(self, bd[k][y], rt=0.01)
        for y in range(cols):
            bdD[y] = hl_bd(self, G5D_[y])
        self.wait(2)
        for y in range(cols):
            del_bd(self, bdD[y])
        del_grids(self, [grid_G])

        show_subtitle(self, "可以发现，这里的步骤和《首行叠加法》类似，", "共有n个矩阵要生成，时间复杂度是O(n³)。")
        self.wait(9)
        del_latex(self, LAT_D)

        show_subtitle(self, "不过，聪明的你一定能想到，", "通过《生成矩阵法》调换矩阵的行以后，这些矩阵也都满足十字偶校验约束。")
        sz=SZ_SMALL
        LAT_D = show_latex(self, "<cD>D(n,x)=D(n-1,x-1)⊕D(n-1,x+1)⊕D(n-2,x)", 0, 2.0)
        for k in range(rows):
            for y in range(cols):
                if (k > y):
                    swap_grid(self, G5_[k][y], G5_[y][k])
        self.wait(1)
        show_subtitle(self, "因此，我们同样只需要生成第一个矩阵，", "然后递推即可得到矩阵D，时间复杂度降为了O(n²)。")
        del_grids(self, [[G5_[k][y] for y in (0, 3, 4)] for k in range(rows)])
        for y in range(cols):
            mx = (0*2-cols)*(1+sz)+1
            my = -y*sz
            move_grid(self, G5D_[y], btn_x=mx, lgt_x=mx, btn_y=my, lgt_y=my)
        self.wait(5)
        del_grids(self, [[G5_[k][y] for y in (1,2)] for k in range(rows)])

        show_subtitle(self, "在生成第一个矩阵的过程中，", "每行乘以矩阵H的结果，就是刚才的矩阵K。")
        LAT_DKG = show_latex(self, "<cD>d=<cK>K<cG>g", 0, 1.5)
        ctx = mul_vec_mat_begin(self, w=5, h=5, mat=MAT_K, vec=VEC_G5, mat_color=K_COLOR, vec_color=G_COLOR, res_color=D_COLOR, mat_label="K", vec_label="g", res_label="d")
        self.wait(6)

        show_subtitle(self, "因此，类似Q'(0)=Kq，只需要将g(x)和K直接相乘，", "即可得到第一个矩阵的最后一行，即矩阵D的第一行d。")
        mul_vec_mat_accumulate(self, ctx)
        self.wait(8)
        grid_D = make_grid(self, 5, 1, mat_l=[VEC_D5], btn_y=-2+SZ_DEFAULT, lgt_y=-2+SZ_DEFAULT, btn_c=D_COLOR, lgt_c=D_COLOR)
        mul_vec_mat_cleanup(self, ctx)

        show_subtitle(self, "然后，我们就可以使用十字偶校验约束的递推关系，", "求得之后的行。")
        move_grid(self, grid_D, btn_y=2*SZ_DEFAULT, lgt_y=2*SZ_DEFAULT)
        grid_D_ = [None] * cols
        for y in range(cols):
            grid_D_[y] = make_grid(self, 5, 1, mat_l=[MAT_D5[y][:]], btn_y=-(y-2)*SZ_DEFAULT, lgt_y=-(y-2)*SZ_DEFAULT, btn_c=D_COLOR, lgt_c=D_COLOR, sz=SZ_DEFAULT, show=False)
            trans_grid(self, G5D_[y], grid_D_[y])
        self.wait(2)
        del_grids(self, [grid_D])

        show_subtitle(self, "由于矩阵D是由矩阵H生成的，因此具有以下这些性质。", "这里，n=5，r=3，r'=2。")
        LAT_R = show_latex(self, "<cR>r'=n-r=deg(<cG>g(x)<cR>)", 0, -1.5)
        grid_D5 = make_grid(self, 5, 5, mat_l=MAT_D5, lgt_c=D_COLOR)
        self.wait(10)

        show_subtitle(self, "1. 后r行，第n行最左边的n-r'-1个元素为0。")
        hl_cells(self, [grid_D5], indices=[(0,3),(0,4),(1,4),(3,0),(4,0),(4,1)])
        self.wait(7)
        del_cells(self, [grid_D5], indices=[(0,3),(0,4),(1,4),(3,0),(4,0),(4,1)])

        show_subtitle(self, "2. 后r行，第n行的第n-r'个元素为1。")
        hl_cells(self, [grid_D5], indices=[(0,2),(1,3),(2,4),(2,0),(3,1),(4,2)])
        self.wait(7)
        del_cells(self, [grid_D5], indices=[(0,2),(1,3),(2,4),(2,0),(3,1),(4,2)])

        show_subtitle(self, "3. 后r行，任意一行都不能由别的行叠加，即线性无关。")
        grid_DR1 = make_grid(self, 5, 3, lgt_c=D_COLOR, btn_y=-1*SZ_DEFAULT, lgt_y=-1*SZ_DEFAULT)
        bd = hl_bd(self, grid_DR1)
        self.wait(6)
        del_bd(self, bd)

        show_subtitle(self, "4. 前r'行，任意一行都可以由后r行叠加。")
        grid_DR2 = make_grid(self, 5, 2, lgt_c=D_COLOR, btn_y=1.5*SZ_DEFAULT, lgt_y=1.5*SZ_DEFAULT)
        bd = hl_bd(self, grid_DR2)
        self.wait(5.5)
        del_bd(self, bd)

        show_subtitle(self, "这些性质都不难证明，有兴趣的小伙伴可以自行证明。")
        self.wait(7)
        del_latex(self, LAT_D, LAT_DKG, LAT_R)

#——————————————————————

        show_subtitle(self, "现在，我们有z=g(H)x=Dx。我们可以利用D的性质进行求解。", "接下来，我们需要将z拆解成矩阵D的若干行的叠加，从而表示出x。")
        LAT_ZD = show_latex(self, "<cZ>z=<cG>g(H)<cX>x=<cD>D<cX>x<cZ>", 0, 2.5, show=False)
        trans_latex(self, LAT_Z, LAT_ZD)
        self.wait(2)
        ctx = mul_vec_mat_begin(self, w=5, h=5, mat=MAT_D5, vec=VEC_X5_2, mat_color=D_COLOR, vec_color=X_COLOR, res_color=Z_COLOR, mat_label="D", vec_label="x", res_label="z")
        mul_vec_mat_accumulate(self, ctx)
        grid_X = ctx["grid_vec"]
        grid_Z = ctx["grid_res"]
        set_all_lights(self, grid_X, on=False)
        self.wait(8)

        show_subtitle(self, "由于矩阵D后三行线性无关，", "因此我们只考虑把后三行叠加起来，不考虑前二行。")
        bd = hl_bd(self, grid_DR1)
        self.wait(8)

        show_subtitle(self, "这里，我们尝试将后三行的若干行叠加到现有的z上，使其被消去。")
        self.wait(6)
        del_bd(self, bd)

        show_subtitle(self, "让我们观察z的第一个元素和D的后三行。", "在D的后三行中，第三行的第一个元素为1。")
        hl_cells(self, [grid_D_[2]], indices=[(0,0)])
        hl_cells(self, [grid_Z], indices=[(0,0)])
        self.wait(9)

        show_subtitle(self, "由于z的第一个元素已经为0。如果我们叠加第三行，", "则z的第一个元素会变为1。因此不能叠加第三行。")
        self.wait(10)
        del_cells(self, [grid_D_[2]], indices=[(0,0)])
        del_cells(self, [grid_Z], indices=[(0,0)])

        show_subtitle(self, "我们再看z的第二个元素，该元素为1，", "因此，我们需要将第四行叠加到z上。")
        hl_cells(self, [grid_D_[3]], indices=[(1,0)])
        hl_cells(self, [grid_Z], indices=[(1,0)])
        self.wait(7)

        show_subtitle(self, "现在，z的第二个元素被消去了，", "同时，x的第四个元素被标记为1。")
        toggle_lgt(self, grid_X, 0, 3)
        add_grid(self, grid_D_[3], grid_Z, keep_from=True)
        self.wait(5.5)
        del_cells(self, [grid_D_[3]], indices=[(1,0)])
        del_cells(self, [grid_Z], indices=[(1,0)])

        show_subtitle(self, "我们接着看z的第三个元素。", "由于z的第三个元素变为了1，我们需要叠加D的第五行。")
        hl_cells(self, [grid_D_[4]], indices=[(2,0)])
        hl_cells(self, [grid_Z], indices=[(2,0)])
        self.wait(8)

        show_subtitle(self, "这次，z被彻底消去了，变为了零，", "并且，x的第五个元素被标记为1。")
        toggle_lgt(self, grid_X, 0, 4)
        add_grid(self, grid_D_[4], grid_Z, keep_from=True)
        self.wait(6)
        del_cells(self, [grid_D_[4]], indices=[(2,0)])
        del_cells(self, [grid_Z], indices=[(2,0)])

        show_subtitle(self, "由此，我们通过依次叠加D的后三行，将z的元素依次消去。", "同时，将叠加的行标记为1，也就求得了最终的x。")
        bd = hl_bd(self, grid_DR1)
        bdX = hl_bd(self, grid_X)
        self.wait(10)
        del_bd(self, bd)

        show_subtitle(self, "不难发现这里求得的x是一个特解。")
        self.wait(4)

        show_subtitle(self, "由于前r'行可以表示为后r行的线性叠加，因此我们可以在消去z之前，", "先将其和前r'的任意行叠加，然后再求解。")
        bd = hl_bd(self, grid_DR2)
        self.wait(11)

        show_subtitle(self, "由于前r'行共有2ʳ'种，因此求得的解也有2ʳ'种。")
        self.wait(7)
        del_bd(self, bd)
        del_bd(self, bdX)

        show_subtitle(self, "另一方面，由于矩阵D满足十字偶校验约束，表现出高度的对称性。", "其中，行和列的坐标可以互换。")
        set_all_lights(self, grid_X, on=False)
        set_all_lights(self, grid_Z, on=False)
        toggle_lgt(self, grid_Z, 1, 0)
        toggle_lgt(self, grid_Z, 3, 0)
        LAT_D_ = show_latex(self, "<cD>D(x,y)=D(y,x)", 0, 2.0)
        self.wait(8)

        show_subtitle(self, "因此，我们可以同样只叠加前r行，从右往左进行消去。", "由于结果是相同的，这里不再赘述。")
        grid_DR3 = make_grid(self, 5, 3, lgt_c=D_COLOR, btn_y=1*SZ_DEFAULT, lgt_y=1*SZ_DEFAULT)
        bd = hl_bd(self, grid_DR3)
        hl_cells(self, [grid_D_[1]], indices=[(3,0)])
        hl_cells(self, [grid_Z], indices=[(3,0)])
        toggle_lgt(self, grid_X, 0, 1)
        add_grid(self, grid_D_[1], grid_Z, keep_from=True)
        del_cells(self, [grid_D_[1]], indices=[(3,0)])
        del_cells(self, [grid_Z], indices=[(3,0)])
        hl_cells(self, [grid_D_[0]], indices=[(2,0)])
        hl_cells(self, [grid_Z], indices=[(2,0)])
        toggle_lgt(self, grid_X, 0, 0)
        add_grid(self, grid_D_[0], grid_Z, keep_from=True)
        del_cells(self, [grid_D_[0]], indices=[(2,0)])
        del_cells(self, [grid_Z], indices=[(2,0)])
        self.wait(4)
        del_bd(self, bd)
        mul_vec_mat_cleanup(self, ctx)
        del_grids(self, grid_D_)
        del_grids(self, [grid_D5, grid_DR1, grid_DR2, grid_DR3])
        del_latex(self, LAT_D_)

#——————————————————————

        show_subtitle(self, "细心的小伙伴会发现，这两个式子具有相同的形式。")
        LAT_B = show_latex(self, "<cZ>y=<cP>p(H)<cX>x=<cB>B<cX>x<cZ>", 0, 2.0)
        self.wait(5)

        show_subtitle(self, "既然我们可以在第一个式子用反向叠加法求x，", "为什么不能用相同的方法在第二个式子求x呢？")
        mul_vec_mat(self, w=5, h=5, mat=MAT_D5, vec=VEC_X5, mat_color=D_COLOR, vec_color=X_COLOR, res_color=Z_COLOR, mat_label="D", vec_label="x", res_label="z", wait=2.0)
        mul_vec_mat(self, w=5, h=5, mat=MAT_B5, vec=VEC_X5, mat_color=B_COLOR, vec_color=X_COLOR, res_color=Y_COLOR, mat_label="B", vec_label="x", res_label="y", wait=2.0)

        show_subtitle(self, "这是因为矩阵D是由g(H)生成的，", "具有带状上三角的可回代结构，满足前面说到的四个性质。")
        grid_D = make_grid(self, 5, 5, mat_l=MAT_D5, lgt_c=D_COLOR)
        self.wait(9)
        show_subtitle(self, "而B=p'(H)D破坏了这一结构，不满足这些性质。", "这里，D=g(H)不可逆，因此p'(H)不唯一。")
        grid_B = make_grid(self, 5, 5, mat_l=MAT_B5, lgt_c=B_COLOR, show=False)
        trans_grid(self, grid_D, grid_B)
        self.wait(10)
        del_grids(self, [grid_B])
        show_subtitle(self, "不过，当g=1时，这种解法是可行的，", "尽管这个方法首先需要求出完整的矩阵B。")
        grid_B = make_grid(self, 7, 7, mat_l=MAT7B[7], btn_c=B_COLOR, lgt_c=B_COLOR)
        self.wait(8)
        show_subtitle(self, "同时，因为矩阵B不是三角结构，还需标记每行首个为1的元素的位置来选择。", "因此，直接计算q(H)y会更加方便。")
        self.wait(10)
        del_latex(self, LAT_ZD, LAT_B)
        del_grids(self, [grid_B])

        show_subtitle(self, "最终，我们通过欧几里得法和反向叠加法，", "完成了Bx=y的求解，实现了点灯游戏O(n²)的时间复杂度的算法。")
        run_case(self, 5)

#——————————————————————

        show_title(self, "算法总结")

        table = show_algo_table(self, x=0.0, y=0.0, font_size=20, row_gap=0.08, col_gap=0.5)
        show_subtitle(self, "以上是O(n²)时间复杂度算法的总结。")
        self.wait(6)
        show_subtitle(self, "向量和矩阵的乘法，欧几里得算法，逆向消元法，", "理论上通过卷积、FFT或牛顿迭代法，是有可能优化到O(n·log(n))的。")
        self.wait(13)
        hide_algo_table(self, table)
        show_algo_time_table(self)
        show_subtitle(self, "考虑到UP主《信号与系统》、《数字信号处理》、《数值分析》等课程较差，", "暂时就不研究了。有兴趣的小伙伴可自行研究并留言。")
        self.wait(13)
        show_subtitle(self, "如果对视频中的内容有疑问，觉得视频内容表述不清，", "或者发现视频中的任何错误，也请小伙伴们多多留言和指证。谢谢观看！")
        self.wait(13)
        hide_algo_time_table(self)

        show_title(self, "参考文献")

        TOP_Y = 2
        sy_l = calc_shift_y_for_top(self, LATEX_LEFT,   TOP_Y, shift_x=-4.75)
        sy_c = calc_shift_y_for_top(self, LATEX_CENTER, TOP_Y, shift_x= 0.5)
        sy_r = calc_shift_y_for_top(self, LATEX_RIGHT,  TOP_Y, shift_x= 4.75)
        show_center_latex(self, LATEX_LEFT,   shift_x=-4.5, shift_y=sy_l, replace_old=False)
        show_center_latex(self, LATEX_CENTER, shift_x= 0.25, shift_y=sy_c, replace_old=False)
        show_center_latex(self, LATEX_RIGHT,  shift_x= 4.5, shift_y=sy_r, replace_old=False)
        self.wait(12)
        remove_center_latex(self)
        self.wait(1)
