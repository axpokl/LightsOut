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

# GL3预览不写日志；导出时正常生成。只拦截本模块约定的5个日志文件。
# 使用模块内open，不修改builtins.open，也不修改任何GL2原函数。
import builtins as _gl3_builtins
import io as _gl3_io
import os as _gl3_os
import sys as _gl3_sys

def _gl3_logs_enabled():
    option = _gl3_os.environ.get("LIGHTS_OUT_EXPORT_LOGS")
    if option is not None: return option == "1"
    return any(arg in ("-w", "--write_file") or (arg.startswith("-w") and not arg.startswith("--")) for arg in _gl3_sys.argv[1:])

def open(file, mode="r", *args, **kwargs):
    logs = {"subtitle.txt", "subtitle_raw.txt", "title.txt", "latex.txt", "normal.txt"}
    name = _gl3_os.fsdecode(file) if isinstance(file, (str, bytes, _gl3_os.PathLike)) else ""
    if name in logs and any(flag in mode for flag in "wax+") and not _gl3_logs_enabled():
        return _gl3_io.BytesIO() if "b" in mode else _gl3_io.StringIO()
    return _gl3_builtins.open(file, mode, *args, **kwargs)

def _gl3_trim(a):
    a = [int(v) & 1 for v in a]
    while len(a) > 1 and a[-1] == 0:
        a.pop()
    return a or [0]

def _gl3_int(a):
    return sum((int(v) & 1) << i for i, v in enumerate(a))

def _gl3_vec(a, width=None):
    width = max(1, a.bit_length()) if width is None else width
    return [(a >> i) & 1 for i in range(width)]

def _gl3_mul(a, b):
    c = 0
    while b:
        if b & 1: c ^= a
        a <<= 1
        b >>= 1
    return c

def _gl3_divmod(a, b):
    if not b: raise ValueError("多项式除数不能为0")
    q = 0
    while a and a.bit_length() >= b.bit_length():
        k = a.bit_length() - b.bit_length()
        q ^= 1 << k
        a ^= b << k
    return q, a

def _gl3_inverse(p, n):
    if n < 1 or not (p & 1): raise ValueError("模t^n求逆要求n>=1且常数项为1")
    g, k = 1, 1
    while k < n:
        k = min(2*k, n)
        g = _gl3_mul(p, _gl3_mul(g, g)) & ((1 << k)-1)
    return g

def _gl3_fast_divmod(a, b):
    if not b: raise ValueError("多项式除数不能为0")
    if a.bit_length() < b.bit_length(): return 0, a
    m, n = a.bit_length()-1, b.bit_length()-1
    d = m-n+1
    ar = _gl3_int(_gl3_vec(a, m+1)[::-1])
    br = _gl3_int(_gl3_vec(b, n+1)[::-1])
    qr = _gl3_mul(ar, _gl3_inverse(br, d)) & ((1 << d)-1)
    q = _gl3_int(_gl3_vec(qr, d)[::-1])
    return q, a ^ _gl3_mul(b, q)

def _gl3_poly(a):
    terms = ["1" if i == 0 else "t" if i == 1 else "t^"+str(i) for i in range(a.bit_length()) if (a >> i) & 1]
    return "+".join(terms[::-1]) or "0"

def _gl3_fib_pair(n, c=False):
    if n == 0: return 1,0
    k = n//2
    fk, fm = _gl3_fib_pair(k,c)
    even = _gl3_mul(fk^fm,fk^fm)
    odd = _gl3_mul(3 if c else 2,_gl3_mul(fk,fk))
    if n&1: return odd,even
    prev = _gl3_mul(3 if c else 2,_gl3_mul(fm,fm))
    return even,prev

def _gl3_karatsuba(a,b):
    n = max(a.bit_length(),b.bit_length())
    if n <= 2: return _gl3_mul(a,b)
    m = (n+1)//2
    mask = (1 << m)-1
    a0,a1,b0,b1 = a&mask,a>>m,b&mask,b>>m
    p0,p2 = _gl3_karatsuba(a0,b0),_gl3_karatsuba(a1,b1)
    p1 = _gl3_karatsuba(a0^a1,b0^b1)^p0^p2
    return p0^(p1<<m)^(p2<<(2*m))

def _gl3_mm(a,b):
    return tuple(tuple(_gl3_mul(a[i][0],b[0][j])^_gl3_mul(a[i][1],b[1][j]) for j in range(2)) for i in range(2))

def _gl3_apply(a,b,m):
    return (_gl3_mul(a,m[0][0])^_gl3_mul(b,m[1][0]),_gl3_mul(a,m[0][1])^_gl3_mul(b,m[1][1]))

def _gl3_hgcd(a,b,events=None,level=0):
    ident = ((1,0),(0,1))
    n = a.bit_length()-1
    if not a or (b and b.bit_length() > a.bit_length()): raise ValueError("Half-GCD要求deg(A)>=deg(B)")
    m = (n+1)//2
    if not b or b.bit_length()-1 < m: return ident
    if events is not None: events.append((level,"进入Half-GCD，目标deg(B)<"+str(m),a,b,ident))
    if n <= 3:
        matrix = ident
        while b and b.bit_length()-1 >= m:
            q,r = _gl3_fast_divmod(a,b)
            matrix = _gl3_mm(matrix,((0,1),(1,q)))
            a,b = b,r
        if events is not None: events.append((level,"基础情形：精确Euclid",a,b,matrix))
        return matrix
    first = _gl3_hgcd(a>>m,b>>m,events,level+1)
    c,d = _gl3_apply(a,b,first)
    if events is not None: events.append((level,"高半段得到M1，再作用到完整A/B",c,d,first))
    if not d or d.bit_length()-1 < m: return first
    q,e = _gl3_fast_divmod(c,d)
    matrix = _gl3_mm(first,((0,1),(1,q)))
    if events is not None: events.append((level,"精确除法修正：Q="+_gl3_poly(q),d,e,matrix))
    if not e or e.bit_length()-1 < m: return matrix
    shift = 2*m-(d.bit_length()-1)
    second = _gl3_hgcd(d>>shift,e>>shift,events,level+1)
    matrix = _gl3_mm(matrix,second)
    c,d = _gl3_apply(a,b,matrix)
    if events is not None: events.append((level,"第二次递归合并：M=M1 E(Q) M2",c,d,matrix))
    return matrix

def _gl3_laurent(vec):
    result,power = {},{0:1}
    for bit in vec:
        if bit:
            for r,v in power.items(): result[r] = result.get(r,0)^v
        new = {}
        for r,v in power.items():
            new[r-1] = new.get(r-1,0)^v
            new[r+1] = new.get(r+1,0)^v
        power = {r:v for r,v in new.items() if v}
    return {r:v for r,v in result.items() if v}

def _gl3_transform(values, inverse=False, method="fft", modulus=17, root=3):
    # 小规模教学用radix-2变换；NTT使用17为模数，原根3，支持长度<=16。
    n = len(values)
    if n < 1 or n&(n-1): raise ValueError("变换长度必须是2的幂")
    if method not in ("fft","ntt"): raise ValueError("method应为fft/ntt")
    if method == "ntt" and (modulus-1)%n: raise ValueError("NTT长度必须整除modulus-1")
    bits = n.bit_length()-1
    indices = [int(format(i,"0"+str(bits)+"b")[::-1],2) for i in range(n)] if n>1 else [0]
    a = [complex(values[i]) if method == "fft" else int(values[i])%modulus for i in indices]
    stages = [("位倒序",a[:],[])]
    length = 2
    while length <= n:
        if method == "fft":
            angle = (2 if inverse else -2)*np.pi/length
            omega = complex(np.cos(angle),np.sin(angle))
        else:
            omega = pow(root,(modulus-1)//length,modulus)
            if inverse: omega = pow(omega,modulus-2,modulus)
        pairs = []
        for left in range(0,n,length):
            w = 1
            for j in range(length//2):
                i,k = left+j,left+j+length//2
                u,v = a[i],a[k]*w
                if method == "ntt": v %= modulus
                a[i],a[k] = u+v,u-v
                if method == "ntt": a[i],a[k] = a[i]%modulus,a[k]%modulus
                pairs.append((i,k,u,v,a[i],a[k]))
                w *= omega
                if method == "ntt": w %= modulus
        stages.append(("蝶形长度 "+str(length),a[:],pairs))
        length *= 2
    if inverse:
        a = [v/n for v in a] if method == "fft" else [v*pow(n,modulus-2,modulus)%modulus for v in a]
        stages.append(("逆变换归一化",a[:],[]))
    return a,stages

#——————————————————————
# GL3动画层：每个系数都是独立Mobject，拆分/移位/乘法/消元均移动系数块。
def _gl3_context():
    return {"objects": [], "rows": [], "grids": [], "result": None}

def _gl3_fmt(value):
    if isinstance(value, complex):
        r, im = round(value.real,2),round(value.imag,2)
        if abs(im) < 0.005: value = r
        else: return (str(r) if r else "")+("+" if r and im>0 else "")+str(im)+"i"
    return str(int(value)) if isinstance(value,(int,float,np.integer,np.floating)) and value == int(value) else str(value)

def _gl3_text(scene, ctx, text, y=0, x=0, color=WHITE, size=24, width=12, rt=0.25):
    obj = Text(str(text),font=FONT_DEFAULT,font_size=size,color=color)
    if obj.get_width() > width: obj.set_width(width)
    obj.move_to(np.array([x,y,0.0]))
    ctx["objects"].append(obj)
    scene.play(FadeIn(obj),run_time=rt)
    return obj

def _gl3_tile(value, position, sz, color, empty=False):
    box = Square(side_length=sz*0.92).set_stroke(color,1.5,0.35 if empty else 0.9)
    box.set_fill(color,opacity=0 if empty else 0.32 if value else 0.06)
    digit = Text("0" if empty else _gl3_fmt(value),font=FONT_DEFAULT,font_size=21,color=color)
    if empty: digit.set_opacity(0)
    if digit.get_width() > sz*0.82: digit.set_width(sz*0.82)
    if digit.get_height() > sz*0.64: digit.set_height(sz*0.64)
    group = VGroup(box,digit)
    group.move_to(np.array(position))
    return group

def _gl3_row(scene, ctx, vec, label, y, color=P_COLOR, sz=0.46, start=0, indices=False, rt=0.3, x=0, visible=True):
    values = list(vec)
    if not values: raise ValueError("系数向量不能为空")
    sz = min(sz,10.6/len(values))
    tiles,foot = VGroup(),VGroup()
    for i,value in enumerate(values):
        pos = np.array([x+(i-(len(values)-1)/2)*sz,y,0.0])
        tiles.add(_gl3_tile(value,pos,sz,color,empty=not visible))
        if indices:
            tag = Text(str(start+i),font=FONT_DEFAULT,font_size=13,color=GREY)
            tag.move_to(pos+np.array([0,-sz*0.75,0]))
            foot.add(tag)
    lab = Text(str(label) if label else "0",font=FONT_DEFAULT,font_size=21,color=color)
    if not label: lab.set_opacity(0)
    if lab.get_width() > 1.35: lab.set_width(1.35)
    lab.move_to(np.array([x-len(values)*sz/2-0.85,y,0]))
    root = VGroup(tiles,foot,lab)
    row = {"root":root,"tiles":tiles,"values":values[:],"color":color,"sz":sz,"start":start,"label":lab,"foot":foot}
    ctx["objects"].append(root)
    ctx["rows"].append(row)
    scene.play(FadeIn(root),run_time=rt)
    return row

def _gl3_set_tile(row, i, value, empty=False):
    row["values"][i] = value
    row["tiles"][i].become(_gl3_tile(value,row["tiles"][i].get_center(),row["sz"],row["color"],empty))

def _gl3_transfer(scene, src, dst, mapping, rt=0.65, arc=0.18, keep=True):
    # mapping=[(源位置,目标位置),...]；复制后移动，或直接将源系数搬走。
    tokens,anims = [],[]
    for i,j in mapping:
        token = src["tiles"][i].copy()
        target = _gl3_tile(src["values"][i],dst["tiles"][j].get_center(),dst["sz"],dst["color"])
        scene.add(token)
        tokens.append((token,i,j))
        anims.append(Transform(token,target,path_arc=arc))
        if not keep: _gl3_set_tile(src,i,src["values"][i],empty=True)
    if anims: scene.play(*anims,run_time=rt)
    for token,i,j in tokens:
        _gl3_set_tile(dst,j,src["values"][i])
        scene.remove(token)

def _gl3_update(scene, row, values, rt=0.35, indices=None):
    values = list(values)
    if len(values) != len(row["values"]): raise ValueError("更新必须保持行长度")
    chosen = list(range(len(values))) if indices is None else list(indices)
    animations = [Transform(row["tiles"][i],_gl3_tile(values[i],row["tiles"][i].get_center(),row["sz"],row["color"])) for i in chosen]
    if animations: scene.play(*animations,run_time=rt)
    row["values"] = values[:]

def _gl3_focus(scene, objects, rt=0.3, color=HL_COLOR_2):
    frames = [SurroundingRectangle(o,buff=0.04).set_stroke(color,2).set_fill(opacity=0) for o in objects]
    scene.play(*[ShowCreation(f) for f in frames],run_time=rt)
    return frames

def _gl3_unfocus(scene, frames, rt=0.2):
    if frames: scene.play(*[FadeOut(f) for f in frames],run_time=rt)

def _gl3_xor(scene, src, dst, mapping=None, rt=0.55):
    # 一个源贡献到一个目标；按列碰撞。1+1时两个1向两侧消散，留下0。
    if mapping is None: mapping = [(i,i) for i in range(min(len(src["values"]),len(dst["values"])))]
    mapping = [(i,j) for i,j in mapping if src["values"][i]]
    tokens = []
    for i,j in mapping:
        token = src["tiles"][i].copy()
        scene.add(token)
        tokens.append((token,i,j,dst["values"][j]))
    if tokens:
        scene.play(*[token.animate.move_to(dst["tiles"][j].get_center()) for token,i,j,old in tokens],run_time=rt)
        animations = []
        ghosts = []
        for token,i,j,old in tokens:
            if old:
                ghost = dst["tiles"][j].copy()
                scene.add(ghost)
                ghosts.append(ghost)
                animations.extend([FadeOut(token,shift=LEFT*0.18),FadeOut(ghost,shift=RIGHT*0.18)])
                _gl3_set_tile(dst,j,0)
            else:
                animations.append(FadeOut(token))
                _gl3_set_tile(dst,j,1)
        scene.play(*animations,run_time=rt*0.7)
        scene.remove(*[t for t,i,j,o in tokens],*ghosts)

def _gl3_product_terms(scene, row_a, row_b, dst, rt=0.3, shift=0, ordinary=False):
    # 每个a_i,b_j从原位置飞到两条中间轨道，逐项乘积再落入次数i+j。
    for j,b in enumerate(row_b["values"]):
        if not b: continue
        frames = _gl3_focus(scene,[row_b["tiles"][j]],rt)
        tokens,ones = [],[]
        for i,a in enumerate(row_a["values"]):
            k = i+j+shift
            if not 0 <= k < len(dst["values"]): continue
            ta,tb = row_a["tiles"][i].copy(),row_b["tiles"][j].copy()
            target = dst["tiles"][k].get_center()
            scene.add(ta,tb)
            tokens.append((ta,tb,k,a*b))
        if not tokens:
            _gl3_unfocus(scene,frames,rt)
            continue
        scene.play(*[t.animate.move_to(dst["tiles"][k].get_center()+np.array([0,offset,0])) for ta,tb,k,value in tokens for t,offset in [(ta,0.65),(tb,1.1)]],run_time=rt*1.5)
        for ta,tb,k,value in tokens:
            target = _gl3_tile(value,dst["tiles"][k].get_center()+UP*0.65,dst["sz"],X_COLOR)
            scene.play(Transform(ta,target),FadeOut(tb),run_time=rt)
            if value: ones.append((ta,k))
            else: scene.play(FadeOut(ta),run_time=rt*0.5)
        if ordinary:
            values = dst["values"][:]
            scene.play(*[t.animate.move_to(dst["tiles"][k].get_center()) for t,k in ones],run_time=rt)
            for t,k in ones: values[k] += 1
            _gl3_update(scene,dst,values,rt)
            scene.remove(*[t for t,k in ones])
        else:
            for t,k in ones:
                one = {"tiles":VGroup(t),"values":[1]}
                _gl3_xor(scene,one,dst,[(0,k)],rt)
                scene.remove(t)
        scene.remove(*[t for ta,tb,k,v in tokens for t in (ta,tb)])
        _gl3_unfocus(scene,frames,rt)

def _gl3_numbers(scene, ctx, values, label, y, color=WHITE, visible=True):
    return _gl3_row(scene,ctx,values,label,y,color,sz=min(0.88,10.6/len(values)),visible=visible)

def clear_demo(scene, ctx, rt=0.3):
    if ctx.get("grids"): del_grids(scene,ctx["grids"],rt=rt)
    if ctx["objects"]: scene.play(*[FadeOut(obj) for obj in ctx["objects"]],run_time=rt)
    ctx["objects"],ctx["rows"],ctx["grids"] = [],[],[]

def show_poly_transform(scene, vec, kind="square", split=None, precision=None, rt=0.7):
    ctx = _gl3_context()
    a = list(vec)
    source = _gl3_row(scene,ctx,a,"A",1.4,indices=True)
    if kind in ("split","merge"):
        m = split if split is not None else (len(a)+1)//2
        if not 0 < m < len(a): raise ValueError("拆分点必须位于向量内部")
        low = _gl3_row(scene,ctx,[0]*m,"A低",0.1,F_COLOR,x=-2.5,visible=False)
        high = _gl3_row(scene,ctx,[0]*(len(a)-m),"A高",0.1,Q_COLOR,x=2.5,visible=False)
        cutx = (source["tiles"][m-1].get_center()[0]+source["tiles"][m].get_center()[0])/2
        cut = DashedLine(np.array([cutx,1.9,0]),np.array([cutx,0.9,0]),color=HL_COLOR_2)
        ctx["objects"].append(cut)
        scene.play(ShowCreation(cut),run_time=rt)
        _gl3_transfer(scene,source,low,[(i,i) for i in range(m)],rt,arc=0.25,keep=False)
        _gl3_transfer(scene,source,high,[(i,i-m) for i in range(m,len(a))],rt,arc=-0.25,keep=False)
        _gl3_text(scene,ctx,"切开系数行；高段的第0项对应原来的t^"+str(m),-1.6,size=23)
        if kind == "merge":
            result = _gl3_row(scene,ctx,[0]*len(a),"合并",-0.9,X_COLOR,visible=False)
            _gl3_transfer(scene,low,result,[(i,i) for i in range(m)],rt,arc=0.2,keep=False)
            _gl3_transfer(scene,high,result,[(i,i+m) for i in range(len(a)-m)],rt,arc=-0.2,keep=False)
            ctx["result"] = a
        else: ctx["result"] = (a[:m],a[m:])
    elif kind == "reverse":
        result = _gl3_row(scene,ctx,[0]*len(a),"倒序",-0.3,X_COLOR,indices=True,visible=False)
        for i in range(len(a)):
            _gl3_transfer(scene,source,result,[(i,len(a)-1-i)],rt/2,arc=0.4,keep=False)
        _gl3_text(scene,ctx,"a[i]搬到a[n-1-i]；倒序保留指定长度",-1.6)
        ctx["result"] = a[::-1]
    elif kind == "square":
        result = _gl3_row(scene,ctx,[0]*(2*len(a)-1),"A平方",-0.3,X_COLOR,indices=True,visible=False)
        _gl3_transfer(scene,source,result,[(i,2*i) for i in range(len(a))],rt,arc=0.2,keep=False)
        odd = list(range(1,len(result["values"]),2))
        for j in odd: _gl3_set_tile(result,j,0)
        frames = _gl3_focus(scene,[result["tiles"][j] for j in odd],rt/2)
        _gl3_unfocus(scene,frames)
        _gl3_text(scene,ctx,"每项的指数翻倍：系数块拉开，中间补0",-1.6)
        ctx["result"] = result["values"][:]
    elif kind == "truncate":
        k = precision if precision is not None else max(1,len(a)//2)
        if not 1 <= k <= len(a): raise ValueError("截断示例精度应在1和向量长度之间")
        result = _gl3_row(scene,ctx,[0]*k,"低次保留",-0.3,X_COLOR,indices=True,visible=False)
        _gl3_transfer(scene,source,result,[(i,i) for i in range(k)],rt,keep=False)
        scene.play(*[FadeOut(source["tiles"][i],shift=RIGHT*0.8+DOWN*0.4) for i in range(k,len(a))],run_time=rt)
        _gl3_text(scene,ctx,"模t^"+str(k)+"：低次系数搬入结果，高次项移出画面",-1.6)
        ctx["result"] = a[:k]
    else: raise ValueError("未知系数变换")
    return ctx

def show_poly_product(scene, vec_a, vec_b, mode="multiply", rt=0.4):
    ctx = _gl3_context()
    a,b = list(vec_a),list(vec_b)
    if not a or not b: raise ValueError("输入不能为空")
    n = len(a)+len(b)-1
    ga = _gl3_row(scene,ctx,a,"A／核",1.6,P_COLOR)
    gb = _gl3_row(scene,ctx,b,"B／输入",0.8,Q_COLOR)
    out = _gl3_row(scene,ctx,[0]*n,"输出C",-1.2,X_COLOR,indices=True)
    if mode == "multiply":
        _gl3_text(scene,ctx,"系数相乘后落到次数i+j；落在同一格的两个1相互抵消",-2.1,size=22)
        _gl3_product_terms(scene,ga,gb,out,rt)
    elif mode == "convolution":
        _gl3_text(scene,ctx,"将核倒序后滑动；重叠位置相乘，异或后落入一个输出格",-2.1,size=22)
        sz = min(0.46,10.6/(n+len(a)))
        # 同一坐标轴：核第i项在输出k时位于信号位置k-i。
        axis_x = lambda j:(j-(len(b)-1)/2)*sz
        signal = _gl3_row(scene,ctx,b,"信号",0.2,Y_COLOR,sz=sz)
        scene.play(FadeOut(gb["root"]),run_time=rt)
        slider = _gl3_row(scene,ctx,a,"滑动核",-0.45,F_COLOR,sz=sz)
        scene.play(*[slider["tiles"][i].animate.move_to(np.array([axis_x(-i),-0.45,0])) for i in range(len(a))],FadeOut(slider["label"]),run_time=rt)
        for k in range(n):
            scene.play(*[slider["tiles"][i].animate.move_to(np.array([axis_x(k-i),-0.45,0])) for i in range(len(a))],run_time=rt)
            pairs = [(i,k-i) for i in range(len(a)) if 0<=k-i<len(b)]
            frames = _gl3_focus(scene,[slider["tiles"][i] for i,j in pairs]+[signal["tiles"][j] for i,j in pairs],rt/2)
            value = 0
            tokens = []
            for i,j in pairs:
                if a[i]&b[j]:
                    t = slider["tiles"][i].copy()
                    scene.add(t)
                    tokens.append(t)
            for t in tokens:
                one = {"tiles":VGroup(t),"values":[1]}
                _gl3_xor(scene,one,out,[(0,k)],rt)
                scene.remove(t)
                value ^= 1
            if not tokens: _gl3_update(scene,out,out["values"],rt/2,[k])
            _gl3_unfocus(scene,frames,rt/2)
    else: raise ValueError("mode应为multiply/convolution")
    ctx["result"] = out["values"][:]
    return ctx

def show_divide_conquer(scene, tree, max_depth=2, rt=0.5):
    ctx = _gl3_context()
    nodes = []
    def visit(node, depth, x, span, parent=None):
        y = 1.65-depth*1.1
        obj = Text(str(node["label"]),font=FONT_DEFAULT,font_size=22,color=F_COLOR)
        if obj.get_width()>span*0.8: obj.set_width(span*0.8)
        obj.move_to(np.array([x,y,0]))
        if parent is None:
            scene.play(FadeIn(obj),run_time=rt)
        else:
            link = Line(parent.get_bottom(),obj.get_top(),stroke_width=1.5,color=GREY)
            ctx["objects"].append(link)
            token = parent.copy()
            scene.add(token)
            scene.play(ShowCreation(link),Transform(token,obj),run_time=rt)
            scene.remove(token)
            scene.add(obj)
        ctx["objects"].append(obj)
        children = []
        if depth<max_depth:
            raw = node.get("children",[])
            for i,child in enumerate(raw):
                children.append(visit(child,depth+1,x+(i-(len(raw)-1)/2)*span/len(raw),span/len(raw),obj))
        if children:
            tokens = [child.copy() for child in children]
            scene.add(*tokens)
            scene.play(*[token.animate.move_to(obj.get_center()).scale(0.5) for token in tokens],run_time=rt)
            scene.play(*[FadeOut(token) for token in tokens],run_time=rt/2)
            frames = _gl3_focus(scene,[obj],rt/2)
            _gl3_unfocus(scene,frames,rt/2)
        return obj
    visit(tree,0,0,11)
    _gl3_text(scene,ctx,"父问题分出子问题；子问题的结果沿连线汇回父问题",-1.8)
    return ctx

# 倍增运算的可视化：平方搬到偶数位，按公式移位，XOR抵消。
def _gl3_fib_step(scene, ctx, n, c=False, y=0.0, rt=0.45):
    k = n//2
    fk,fm = _gl3_fib_pair(k,c)
    width = k+1
    a = _gl3_row(scene,ctx,_gl3_vec(fk,width),"c[k]" if c else "f[k]",1.3+y,C_COLOR if c else F_COLOR)
    if not n&1:
        b = _gl3_row(scene,ctx,_gl3_vec(fm,width),"前一项",0.55+y,Q_COLOR)
        _gl3_xor(scene,b,a,rt=rt)
        label = Text("两项XOR",font=FONT_DEFAULT,font_size=21,color=a["color"]).move_to(a["label"].get_center())
        if label.get_width()>1.35: label.set_width(1.35)
        scene.play(Transform(a["label"],label),run_time=rt/2)
    out = _gl3_row(scene,ctx,[0]*(n+1),"c新" if c else "f新",-0.65+y,X_COLOR,indices=True)
    mapping = [(i,2*i+(1 if n&1 else 0)) for i in range(width) if 2*i+(1 if n&1 else 0)<=n]
    _gl3_transfer(scene,a,out,mapping,rt,arc=0.2)
    if n&1 and c:
        temp = _gl3_row(scene,ctx,[0]*(n+1),"平方",0.2+y,Q_COLOR,visible=False)
        _gl3_transfer(scene,a,temp,[(i,2*i) for i in range(width)],rt)
        _gl3_xor(scene,temp,out,rt=rt)
    for i,value in enumerate(out["values"]): _gl3_set_tile(out,i,value)
    return out

def show_fibonacci_double(scene, n, rt=0.5):
    if n<1: raise ValueError("n必须>=1")
    ctx = _gl3_context()
    path,k = [],n
    while k:
        path.append(k)
        k//=2
    # 逐层真正执行所用倍增公式，而不是直接刷出f/c结果。
    for current in path[::-1]:
        for c in (False,True):
            panel = _gl3_context()
            note = ("c" if c else "f")+"：规模 "+str(current//2)+" → "+str(current)
            _gl3_text(scene,panel,note,2.05)
            out = _gl3_fib_step(scene,panel,current,c,rt=rt)
            _gl3_text(scene,panel,"先XOR再平方" if not current&1 else "平方后右移1位，再加自身平方" if c else "平方后右移1位",-1.7,size=24)
            scene.wait(rt)
            clear_demo(scene,panel)
    f,_ = _gl3_fib_pair(n)
    c,_ = _gl3_fib_pair(n,True)
    _gl3_row(scene,ctx,_gl3_vec(f,n+1),"f最终",0.6,F_COLOR)
    _gl3_row(scene,ctx,_gl3_vec(c,n+1),"c最终",-0.3,C_COLOR)
    ctx["result"] = (_gl3_vec(f,n+1),_gl3_vec(c,n+1))
    return ctx

# 一层Karatsuba的三个分支在画面上真实接收输入，并将结果移动回对应次数。
def show_karatsuba(scene, vec_a, vec_b, depth=1, rt=0.5):
    a,b = _gl3_int(vec_a),_gl3_int(vec_b)
    n = max(len(vec_a),len(vec_b))
    m = (n+1)//2
    width = 2*m
    ctx = _gl3_context()
    ga = _gl3_row(scene,ctx,_gl3_vec(a,width),"A",1.6,P_COLOR)
    gb = _gl3_row(scene,ctx,_gl3_vec(b,width),"B",0.85,Q_COLOR)
    branches = []
    for index,(x,label) in enumerate([(-3.8,"低×低"),(0,"两段和相乘"),(3.8,"高×高")]):
        sa = _gl3_row(scene,ctx,[0]*m,"",-0.1,F_COLOR,sz=0.38,x=x,visible=False)
        sb = _gl3_row(scene,ctx,[0]*m,"",-0.8,Q_COLOR,sz=0.38,x=x,visible=False)
        _gl3_text(scene,ctx,label,-1.55,x=x,size=20,width=3.5)
        offset = m if index==2 else 0
        _gl3_transfer(scene,ga,sa,[(i+offset,i) for i in range(m)],rt)
        _gl3_transfer(scene,gb,sb,[(i+offset,i) for i in range(m)],rt)
        if index==1:
            _gl3_xor(scene,ga,sa,[(i+m,i) for i in range(m)],rt)
            _gl3_xor(scene,gb,sb,[(i+m,i) for i in range(m)],rt)
        branches.append((sa["values"][:],sb["values"][:]))
    scene.wait(rt)
    clear_demo(scene,ctx)
    products = []
    for i,(av,bv) in enumerate(branches):
        # 可继续递归演示；depth=1时在叶节点逐项乘法，展示实际数据运算。
        if depth>1 and m>1:
            panel = show_karatsuba(scene,av,bv,depth-1,rt)
        else: panel = show_poly_product(scene,av,bv,rt=rt*0.7)
        products.append(panel["result"][:])
        scene.wait(rt/2)
        clear_demo(scene,panel)
    p0,pm,p2 = products
    r0 = _gl3_row(scene,ctx,p0,"P0",1.65,F_COLOR)
    r2 = _gl3_row(scene,ctx,p2,"P2",0.9,Q_COLOR)
    middle = _gl3_row(scene,ctx,pm,"Pm",0.15,Y_COLOR)
    _gl3_xor(scene,r0,middle,rt=rt)
    _gl3_xor(scene,r2,middle,rt=rt)
    label = Text("中间项",font=FONT_DEFAULT,font_size=21,color=Y_COLOR).move_to(middle["label"].get_center())
    scene.play(Transform(middle["label"],label),run_time=rt/2)
    _gl3_text(scene,ctx,"中间项 = Pm XOR P0 XOR P2；然后按次数错位相加",-2.05,size=22)
    out = _gl3_row(scene,ctx,[0]*(4*m-1),"AB",-1.1,X_COLOR,indices=True)
    _gl3_xor(scene,r0,out,[(i,i) for i in range(len(p0))],rt)
    _gl3_xor(scene,middle,out,[(i,i+m) for i in range(len(pm))],rt)
    _gl3_xor(scene,r2,out,[(i,i+2*m) for i in range(len(p2))],rt)
    ctx["result"] = out["values"][:len(vec_a)+len(vec_b)-1]
    return ctx

# 带可视化输入和输出的截断乘法；每个部分积搬动到结果行并进行碰撞抵消。
def _gl3_visible_multiply(scene, ctx, a, b, length, title, rt=0.4):
    _gl3_text(scene,ctx,title,2.0,size=23)
    ga = _gl3_row(scene,ctx,a,"左因子",1.2,F_COLOR)
    gb = _gl3_row(scene,ctx,b,"右因子",0.45,Q_COLOR)
    out = _gl3_row(scene,ctx,[0]*length,"乘积",-1.2,X_COLOR,indices=True)
    _gl3_product_terms(scene,ga,gb,out,rt)
    return out

def show_newton_inverse(scene, vec_p, precision, rt=0.4):
    p = _gl3_int(vec_p)
    _gl3_inverse(p,precision)
    ctx = _gl3_context()
    g,k = 1,1
    while k<precision:
        new_k = min(2*k,precision)
        panel = _gl3_context()
        _gl3_text(scene,panel,"Newton：精度 "+str(k)+" → "+str(new_k),2.05)
        old = _gl3_row(scene,panel,_gl3_vec(g,k),"G旧",1.2,Q_COLOR)
        squared = _gl3_row(scene,panel,[0]*(2*k-1),"G旧平方",-0.1,C_COLOR,indices=True)
        _gl3_transfer(scene,old,squared,[(i,2*i) for i in range(k)],rt)
        for i in range(1,2*k-1,2): _gl3_set_tile(squared,i,0)
        _gl3_text(scene,panel,"先将G旧每个系数搬到偶数指数，奇数位置补0",-1.5,size=24)
        scene.wait(rt)
        clear_demo(scene,panel)
        panel = _gl3_context()
        out = _gl3_visible_multiply(scene,panel,_gl3_vec(p&((1<<new_k)-1),new_k),_gl3_vec(_gl3_mul(g,g),2*k-1),new_k,"G新 = P × G旧平方，截断到 "+str(new_k)+"项",rt*0.7)
        g = _gl3_int(out["values"])
        clear_demo(scene,panel)
        panel = _gl3_context()
        check = _gl3_mul(p,g)&((1<<precision)-1)
        row = _gl3_row(scene,panel,_gl3_vec(check,precision),"P G新",0.4,X_COLOR,indices=True)
        brace = _gl3_focus(scene,[row["tiles"][i] for i in range(new_k)],rt)
        _gl3_text(scene,panel,"正确区间扩展到 "+str(new_k)+" 项：1,0,0,...",-1.1)
        scene.wait(rt)
        _gl3_unfocus(scene,brace,rt)
        clear_demo(scene,panel)
        k = new_k
    _gl3_row(scene,ctx,_gl3_vec(g,precision),"截断逆G",0.5,Q_COLOR,indices=True)
    _gl3_text(scene,ctx,"P G = 1 mod t^"+str(precision),-0.6)
    ctx["result"] = _gl3_vec(g,precision)
    return ctx

# 长除法：除数实体先对齐最高项，再落入余式发生XOR；商的相应位置随之点亮。
def _gl3_long_division(scene, vec_a, vec_b, rt=0.45):
    a,b = _gl3_int(vec_a),_gl3_int(vec_b)
    if not b: raise ValueError("除数不能为0")
    ctx = _gl3_context()
    width = max(len(vec_a),len(vec_b))
    rem = _gl3_row(scene,ctx,_gl3_vec(a,width),"余式",1.35,F_COLOR,indices=True)
    den = _gl3_row(scene,ctx,_gl3_vec(b,b.bit_length()),"B",0.45,Q_COLOR)
    qw = max(1,a.bit_length()-b.bit_length()+1)
    quot = _gl3_row(scene,ctx,[0]*qw,"商Q",-1.2,X_COLOR,indices=True)
    aligned = _gl3_row(scene,ctx,[0]*width,"对齐B",-0.4,Q_COLOR,visible=False)
    note = _gl3_text(scene,ctx,"将B移动到最高次项正下方，再异或消去",-2.0,size=23)
    cur,q = a,0
    while cur and cur.bit_length()>=b.bit_length():
        shift = cur.bit_length()-b.bit_length()
        for i in range(width): _gl3_set_tile(aligned,i,0,empty=True)
        _gl3_transfer(scene,den,aligned,[(i,i+shift) for i in range(b.bit_length())],rt)
        frame = _gl3_focus(scene,[aligned["tiles"][shift+b.bit_length()-1],rem["tiles"][cur.bit_length()-1]],rt/2)
        _gl3_xor(scene,aligned,rem,rt=rt)
        q ^= 1<<shift
        cur ^= b<<shift
        _gl3_update(scene,quot,_gl3_vec(q,qw),rt,[shift])
        _gl3_unfocus(scene,frame,rt/2)
    ctx["result"] = (_gl3_vec(q),_gl3_vec(cur))
    return ctx

def show_poly_division(scene, vec_a, vec_b, mode="long", rt=0.45):
    if mode=="long": return _gl3_long_division(scene,vec_a,vec_b,rt)
    if mode!="fast": raise ValueError("mode应为long/fast")
    a,b = _gl3_int(vec_a),_gl3_int(vec_b)
    q,r = _gl3_divmod(a,b)
    if a.bit_length()<b.bit_length(): return _gl3_long_division(scene,vec_a,vec_b,rt)
    m,n = a.bit_length()-1,b.bit_length()-1
    d = m-n+1
    for values in (_gl3_vec(a,m+1),_gl3_vec(b,n+1)):
        panel = show_poly_transform(scene,values,"reverse",rt=rt)
        scene.wait(rt)
        clear_demo(scene,panel)
    ar,br = _gl3_vec(a,m+1)[::-1],_gl3_vec(b,n+1)[::-1]
    panel = show_newton_inverse(scene,br,d,rt)
    inverse = panel["result"][:]
    clear_demo(scene,panel)
    panel = _gl3_context()
    qr = _gl3_visible_multiply(scene,panel,ar,inverse,d,"Q倒序 = A倒序 × B倒序的截断逆",rt)
    qr_values = qr["values"][:]
    clear_demo(scene,panel)
    panel = show_poly_transform(scene,qr_values,"reverse",rt=rt)
    clear_demo(scene,panel)
    panel = show_poly_product(scene,vec_b,_gl3_vec(q,d),rt=rt)
    prod_values = panel["result"][:]
    clear_demo(scene,panel)
    ctx = _gl3_context()
    length = max(len(vec_a),len(prod_values))
    prod = _gl3_row(scene,ctx,prod_values+[0]*(length-len(prod_values)),"BQ",1.2,Q_COLOR)
    rem = _gl3_row(scene,ctx,list(vec_a)+[0]*(length-len(vec_a)),"A → R",-0.1,F_COLOR,indices=True)
    _gl3_xor(scene,prod,rem,rt=rt)
    _gl3_row(scene,ctx,_gl3_vec(q,d),"商Q",-1.15,X_COLOR)
    _gl3_text(scene,ctx,"最后让BQ落入A，逐项XOR，剩下的就是余数R",-2.0,size=23)
    ctx["result"] = (_gl3_vec(q),_gl3_vec(r))
    return ctx

# 矩阵作用不直接赋结果：把输入按矩阵中多项式的每个非零项移位，逐项XOR进输出。
def _gl3_matrix_flow(scene, a, b, matrix, note, rt=0.4):
    ctx = _gl3_context()
    products = [_gl3_mul(v,matrix[i][j]) for i,v in enumerate((a,b)) for j in range(2)]
    width = max([a.bit_length(),b.bit_length(),1]+[p.bit_length() for p in products])
    sz = min(0.4,10.4/width)
    _gl3_text(scene,ctx,note,2.35,size=22)
    _gl3_text(scene,ctx,"M = [ "+_gl3_poly(matrix[0][0])+", "+_gl3_poly(matrix[0][1])+" ; "+_gl3_poly(matrix[1][0])+", "+_gl3_poly(matrix[1][1])+" ]",1.9,size=20)
    ra = _gl3_row(scene,ctx,_gl3_vec(a,max(1,a.bit_length())),"A",1.35,F_COLOR,sz=sz)
    rb = _gl3_row(scene,ctx,_gl3_vec(b,max(1,b.bit_length())),"B",0.65,Q_COLOR,sz=sz)
    rc = _gl3_row(scene,ctx,[0]*width,"A新",-1.05,X_COLOR,sz=sz)
    rd = _gl3_row(scene,ctx,[0]*width,"B新",-1.8,Z_COLOR,sz=sz)
    for j,dst in enumerate((rc,rd)):
        for i,src in enumerate((ra,rb)):
            p = matrix[i][j]
            for shift in range(p.bit_length()):
                if not (p>>shift)&1: continue
                panel = _gl3_context()
                temp = _gl3_row(scene,panel,[0]*width,"移位贡献",-0.15,C_COLOR,sz=sz,visible=False)
                _gl3_text(scene,panel,("A" if i==0 else "B")+" × t^"+str(shift)+" → "+("A新" if j==0 else "B新"),-0.6,size=20)
                _gl3_transfer(scene,src,temp,[(k,k+shift) for k in range(len(src["values"])) if k+shift<width],rt)
                _gl3_xor(scene,temp,dst,rt=rt)
                clear_demo(scene,panel,rt/2)
    ctx["result"] = (_gl3_int(rc["values"]),_gl3_int(rd["values"]))
    return ctx

def _gl3_half_call(scene, a, b, depth, rt):
    n = a.bit_length()-1
    m = (n+1)//2
    if not b or b.bit_length()-1<m: return ((1,0),(0,1))
    if n<=3:
        matrix = ((1,0),(0,1))
        while b and b.bit_length()-1>=m:
            panel = _gl3_long_division(scene,_gl3_vec(a),_gl3_vec(b),rt)
            q,r = map(_gl3_int,panel["result"])
            clear_demo(scene,panel)
            e = ((0,1),(1,q))
            panel = _gl3_matrix_flow(scene,a,b,e,"Euclid变换 E(Q)：A新=B；B新=A+QB",rt)
            clear_demo(scene,panel)
            matrix = _gl3_mm(matrix,e)
            a,b = b,r
        return matrix
    panel = _gl3_context()
    _gl3_text(scene,panel,"Half-GCD：截取高次部分，目标deg(B)<"+str(m),2.1,size=23)
    width = max(a.bit_length(),b.bit_length())
    ra = _gl3_row(scene,panel,_gl3_vec(a,width),"完整A",1.3,F_COLOR,indices=True)
    rb = _gl3_row(scene,panel,_gl3_vec(b,width),"完整B",0.55,Q_COLOR,indices=True)
    hi_a = _gl3_row(scene,panel,[0]*(width-m),"高A",-0.4,F_COLOR,visible=False)
    hi_b = _gl3_row(scene,panel,[0]*(width-m),"高B",-1.15,Q_COLOR,visible=False)
    _gl3_transfer(scene,ra,hi_a,[(i,i-m) for i in range(m,width)],rt)
    _gl3_transfer(scene,rb,hi_b,[(i,i-m) for i in range(m,width)],rt)
    packed = VGroup(hi_a["tiles"].copy(),hi_b["tiles"].copy())
    scene.add(packed)
    scene.play(packed.animate.scale(0.4).move_to(np.array([4.7,-1.5,0])),run_time=rt)
    scene.play(FadeOut(packed),run_time=rt/2)
    clear_demo(scene,panel)
    if depth>0: first = _gl3_half_call(scene,a>>m,b>>m,depth-1,rt)
    else: first = _gl3_hgcd(a>>m,b>>m)
    panel = _gl3_matrix_flow(scene,a,b,first,"递归返回M1：让M1作用到原来的完整A/B",rt)
    c,d = panel["result"]
    clear_demo(scene,panel)
    if not d or d.bit_length()-1<m: return first
    panel = _gl3_long_division(scene,_gl3_vec(c),_gl3_vec(d),rt)
    q,e = map(_gl3_int,panel["result"])
    clear_demo(scene,panel)
    matrix = _gl3_mm(first,((0,1),(1,q)))
    panel = _gl3_matrix_flow(scene,c,d,((0,1),(1,q)),"精确除法修正：交换两项，余式由移位消元得到",rt)
    clear_demo(scene,panel)
    if not e or e.bit_length()-1<m: return matrix
    shift = 2*m-(d.bit_length()-1)
    if depth>0: second = _gl3_half_call(scene,d>>shift,e>>shift,depth-1,rt)
    else: second = _gl3_hgcd(d>>shift,e>>shift)
    panel = _gl3_matrix_flow(scene,d,e,second,"第二次递归返回M2，恢复到完整多项式对",rt)
    clear_demo(scene,panel)
    return _gl3_mm(matrix,second)

def show_half_gcd(scene, vec_a, vec_b, depth=1, rt=0.4):
    a,b = _gl3_int(vec_a),_gl3_int(vec_b)
    if not a or b.bit_length()>a.bit_length(): raise ValueError("要求deg(A)>=deg(B)，且A非零")
    cumulative = ((1,0),(0,1))
    while b:
        matrix = _gl3_half_call(scene,a,b,max(0,depth),rt)
        a,b = _gl3_apply(a,b,matrix)
        cumulative = _gl3_mm(cumulative,matrix)
        if b:
            q,r = _gl3_divmod(a,b)
            panel = _gl3_matrix_flow(scene,a,b,((0,1),(1,q)),"当前Half-GCD已结束；精确推进后进入下一轮",rt)
            clear_demo(scene,panel)
            cumulative = _gl3_mm(cumulative,((0,1),(1,q)))
            a,b = b,r
    ctx = _gl3_context()
    result = _gl3_row(scene,ctx,_gl3_vec(a),"GCD",0.7,G_COLOR,indices=True)
    _gl3_text(scene,ctx,"递归矩阵保留了整个Euclid变换；最后第二项归零",-0.5,size=23)
    ctx["result"],ctx["matrix"] = _gl3_vec(a),cumulative
    return ctx

# Laurent展开：H对应向左/向右两个移位；每次平方/乘H都让核系数真正扩散。
def _gl3_expand_kernel(scene, polynomial, rt=0.35):
    radius = len(polynomial)-1
    ctx = _gl3_context()
    p = _gl3_row(scene,ctx,polynomial,"P系数",1.65,P_COLOR,indices=True)
    power_values = [0]*(2*radius+1)
    power_values[radius] = 1
    power = _gl3_row(scene,ctx,power_values,"当前H幂",0.8,F_COLOR,start=-radius,indices=True)
    kernel = _gl3_row(scene,ctx,[0]*(2*radius+1),"Laurent核",-1.3,X_COLOR,start=-radius,indices=True)
    for degree,bit in enumerate(polynomial):
        focus = _gl3_focus(scene,[p["tiles"][degree]],rt/2)
        if bit: _gl3_xor(scene,power,kernel,rt=rt)
        _gl3_unfocus(scene,focus,rt/2)
        if degree<radius:
            panel = _gl3_context()
            nextrow = _gl3_row(scene,panel,[0]*(2*radius+1),"乘H",-0.3,C_COLOR,start=-radius)
            _gl3_xor(scene,power,nextrow,[(i,i-1) for i in range(1,2*radius+1)],rt)
            _gl3_xor(scene,power,nextrow,[(i,i+1) for i in range(2*radius)],rt)
            _gl3_transfer(scene,nextrow,power,[(i,i) for i in range(2*radius+1)],rt)
            clear_demo(scene,panel)
    result = {i-radius:bit for i,bit in enumerate(kernel["values"]) if bit}
    clear_demo(scene,ctx)
    return result

def _gl3_reflect(scene, ctx, raw, low, n, rt):
    source = _gl3_row(scene,ctx,raw,"无限线",1.3,Z_COLOR,start=low,indices=True)
    target = _gl3_row(scene,ctx,[0]*n,"有限棋盘",-0.8,X_COLOR,indices=True)
    _gl3_transfer(scene,source,target,[(i-low,i) for i in range(n)],rt)
    sz = source["sz"]
    for axis in (-1,n):
        if low<=axis<=low+len(raw)-1:
            x = source["tiles"][axis-low].get_center()[0]
            line = DashedLine(np.array([x,1.85,0]),np.array([x,-0.1,0]),color=HL_COLOR_2)
            ctx["objects"].append(line)
            scene.play(ShowCreation(line),run_time=rt)
    _gl3_text(scene,ctx,"两条虚线是零边界；外侧系数沿反射路径回到棋盘并XOR",-1.9,size=23)
    for pos in range(low,low+len(raw)):
        if 0<=pos<n or pos in (-1,n) or not raw[pos-low]: continue
        j = -2-pos if pos<-1 else 2*n-pos
        tile = source["tiles"][pos-low]
        token = tile.copy()
        scene.add(token)
        axis = -1 if pos<-1 else n
        point = source["tiles"][axis-low].get_center()
        reflected_x = 2*point[0]-tile.get_center()[0]
        scene.play(Transform(token,token.copy().move_to(np.array([reflected_x,0.3,0])),path_arc=np.pi/3 if pos<-1 else -np.pi/3),run_time=rt)
        one = {"tiles":VGroup(token),"values":[1]}
        _gl3_xor(scene,one,target,[(0,j)],rt)
        scene.remove(token)
    return target

def _gl3_toeplitz(scene, kernel, z, rt=0.4):
    a = list(kernel)
    n = len(z)
    if not a or a[0]!=1: raise ValueError("三角Toeplitz核常数项必须为1")
    a = (a+[0]*n)[:n]
    panel = _gl3_context()
    source = _gl3_row(scene,panel,a,"单向核A",1.9,F_COLOR)
    sz = min(0.42,2.5/n)
    entries = []
    root = VGroup()
    # 核系数复制到每条对角线，矩阵由核逐条铺出来。
    for i in range(n):
        row=[]
        for j in range(n):
            value = a[i-j] if i>=j else 0
            tile = _gl3_tile(value,np.array([-2.8+(j-(n-1)/2)*sz,0.1+((n-1)/2-i)*sz,0]),sz,F_COLOR,empty=i>=j)
            row.append(tile)
            root.add(tile)
        entries.append(row)
    panel["objects"].append(root)
    scene.play(FadeIn(root),run_time=rt)
    for k in range(n):
        tokens = [source["tiles"][k].copy() for j in range(n-k)]
        scene.add(*tokens)
        targets = [_gl3_tile(a[k],entries[j+k][j].get_center(),sz,F_COLOR) for j in range(n-k)]
        scene.play(*[Transform(t,target) for t,target in zip(tokens,targets)],run_time=rt)
        for j,target in enumerate(targets): entries[j+k][j].become(target)
        scene.remove(*tokens)
    right = _gl3_row(scene,panel,z,"Z",-1.7,Z_COLOR)
    _gl3_text(scene,panel,"核的第k项铺成矩阵的第k条下对角线",1.05,x=3.0,width=5.0,size=23)
    _gl3_text(scene,panel,"TX=Z 等价于 A(t)X(t)=Z(t) mod t^n",-2.2,size=22)
    scene.wait(rt)
    clear_demo(scene,panel)
    panel = show_newton_inverse(scene,a,n,rt)
    inverse = panel["result"][:]
    clear_demo(scene,panel)
    ctx = _gl3_context()
    out = _gl3_visible_multiply(scene,ctx,list(z),inverse,n,"反卷积：Z与核A的截断逆相乘，得到X",rt)
    ctx["result"] = out["values"][:]
    return ctx

def show_kernel_operator(scene, kernel, vec, mode="forward", polynomial=None, rt=0.4):
    v = list(vec)
    n = len(v)
    if not n: raise ValueError("输入不能为空")
    if mode=="reverse": return _gl3_toeplitz(scene,kernel,v,rt)
    if mode not in ("forward","ones"): raise ValueError("未知核模式")
    if polynomial is not None: kernel = _gl3_expand_kernel(scene,polynomial,rt)
    kernel = {int(r):int(bit)&1 for r,bit in kernel.items() if bit}
    radius = max([abs(r) for r in kernel] or [0])
    if radius>n: raise ValueError("此示例只支持单次反射，核半径必须<=n")
    if any(kernel.get(r,0)!=kernel.get(-r,0) for r in range(radius+1)): raise ValueError("此零边界示例要求对称Laurent核")
    if mode=="ones" and any(vv!=1 for vv in v): raise ValueError("ones要求全1输入")
    coefficients = [kernel.get(i,0) for i in range(-radius,radius+1)]
    ctx = _gl3_context()
    if mode=="forward":
        panel = show_poly_product(scene,coefficients,v,"multiply",rt)
        raw = panel["result"][:]
        clear_demo(scene,panel)
    else:
        # 构建前缀异或：每个核系数真正飞入累加器，累加器再复制到前缀表。
        panel = _gl3_context()
        src = _gl3_row(scene,panel,coefficients,"核",1.5,F_COLOR,start=-radius,indices=True)
        prefix = _gl3_row(scene,panel,[0]*(len(coefficients)+1),"前缀XOR",-0.1,Q_COLOR)
        acc = _gl3_row(scene,panel,[0],"累加器",0.65,X_COLOR,x=4.5)
        for i,bit in enumerate(coefficients):
            _gl3_xor(scene,src,acc,[(i,0)],rt/2)
            _gl3_transfer(scene,acc,prefix,[(0,i+1)],rt/2)
        _gl3_text(scene,panel,"前缀[i+1] = 前缀[i] XOR 核[i]",-1.6)
        scene.wait(rt)
        clear_demo(scene,panel)
        panel = _gl3_context()
        src = _gl3_row(scene,panel,coefficients,"核",1.5,F_COLOR,start=-radius,indices=True)
        pre_values = [0]
        for bit in coefficients: pre_values.append(pre_values[-1]^bit)
        pre = _gl3_row(scene,panel,pre_values,"前缀XOR",0.65,Q_COLOR)
        rawrow = _gl3_row(scene,panel,[0]*(n+2*radius),"无限输出",-1.1,Z_COLOR,start=-radius,indices=True)
        window = None
        for index,pos in enumerate(range(-radius,n+radius)):
            left,right = max(-radius,pos-(n-1)),min(radius,pos)
            selected = VGroup(*[src["tiles"][i+radius] for i in range(left,right+1)])
            box = SurroundingRectangle(selected,buff=0.04).set_stroke(HL_COLOR_2,2)
            if window is None:
                window=box
                scene.play(ShowCreation(window),run_time=rt)
            else: scene.play(Transform(window,box),run_time=rt)
            l,r = left+radius,right+radius+1
            _gl3_xor(scene,pre,rawrow,[(l,index)],rt/2)
            _gl3_xor(scene,pre,rawrow,[(r,index)],rt/2)
        if window is not None: scene.play(FadeOut(window),run_time=rt)
        raw = rawrow["values"][:]
        clear_demo(scene,panel)
    target = _gl3_reflect(scene,ctx,raw,-radius,n,rt)
    ctx["result"],ctx["raw"],ctx["kernel"] = target["values"][:],raw,kernel
    return ctx

# 一个蝶形：v先经过乘旋转因子w的节点，再分成加/减两路，分别与u合并后落入输出。
def _gl3_butterfly(scene, src, dst, i, k, weighted, plus, minus, w, rt):
    panel = _gl3_context()
    gate = _gl3_text(scene,panel,"× ("+_gl3_fmt(w)+")",0.15,x=0,size=20,width=3.0)
    add = _gl3_text(scene,panel,"+",-0.45,x=-2.0,size=26)
    sub = _gl3_text(scene,panel,"−",-0.45,x=2.0,size=26)
    ui,vi = src["tiles"][i].copy(),src["tiles"][k].copy()
    scene.add(ui,vi)
    scene.play(ui.animate.move_to(np.array([-3.1,0.2,0])),vi.animate.move_to(np.array([0,0.65,0])),run_time=rt)
    weighted_tile = _gl3_tile(weighted,np.array([0,-0.1,0]),src["sz"],Q_COLOR)
    scene.play(Transform(vi,weighted_tile),run_time=rt)
    u2,v2 = ui.copy(),vi.copy()
    scene.add(u2,v2)
    scene.play(ui.animate.move_to(np.array([-2.5,-0.45,0])),vi.animate.move_to(np.array([-1.5,-0.45,0])),u2.animate.move_to(np.array([1.5,-0.45,0])),v2.animate.move_to(np.array([2.5,-0.45,0])),run_time=rt)
    plus_tile = _gl3_tile(plus,np.array([-2,-0.45,0]),dst["sz"],X_COLOR)
    minus_tile = _gl3_tile(minus,np.array([2,-0.45,0]),dst["sz"],X_COLOR)
    scene.play(Transform(ui,plus_tile),FadeOut(vi),Transform(u2,minus_tile),FadeOut(v2),run_time=rt)
    scene.play(ui.animate.move_to(dst["tiles"][i].get_center()),u2.animate.move_to(dst["tiles"][k].get_center()),run_time=rt)
    _gl3_set_tile(dst,i,plus)
    _gl3_set_tile(dst,k,minus)
    scene.remove(ui,vi,u2,v2)
    clear_demo(scene,panel,rt/2)

def _gl3_transform_flow(scene, values, method, inverse, name, rt):
    result,stages = _gl3_transform(values,inverse=inverse,method=method)
    n = len(values)
    bits = n.bit_length()-1
    previous = list(values)
    for stage,current,pairs in stages:
        ctx = _gl3_context()
        _gl3_text(scene,ctx,name+"："+stage,2.05,size=24)
        src = _gl3_numbers(scene,ctx,previous,"输入",1.2,F_COLOR)
        dst = _gl3_numbers(scene,ctx,[0]*n,"输出",-1.25,X_COLOR,visible=False)
        if stage=="位倒序":
            permutation = [int(format(i,"0"+str(bits)+"b")[::-1],2) for i in range(n)] if n>1 else [0]
            _gl3_transfer(scene,src,dst,[(permutation[i],i) for i in range(n)],rt*2,arc=0.35)
        elif pairs:
            length = int(stage.split()[-1])
            if method=="fft":
                angle = (2 if inverse else -2)*np.pi/length
                omega = complex(np.cos(angle),np.sin(angle))
            else:
                omega = pow(3,16//length,17)
                if inverse: omega=pow(omega,15,17)
            for i,k,u,v,s,d in pairs:
                j = i%length
                w = omega**j if method=="fft" else pow(omega,j,17)
                _gl3_butterfly(scene,src,dst,i,k,v,s,d,w,rt)
        else:
            gate = _gl3_text(scene,ctx,"÷ "+str(n) if method=="fft" else "× "+str(pow(n,15,17))+" mod17",0.1,size=22)
            for i in range(n):
                token = src["tiles"][i].copy()
                scene.add(token)
                scene.play(token.animate.move_to(np.array([0,0.5,0])),run_time=rt)
                scene.play(Transform(token,_gl3_tile(current[i],np.array([0,-0.35,0]),dst["sz"],X_COLOR)),run_time=rt)
                scene.play(token.animate.move_to(dst["tiles"][i].get_center()),run_time=rt)
                _gl3_set_tile(dst,i,current[i])
                scene.remove(token)
        scene.wait(rt)
        clear_demo(scene,ctx)
        previous = current[:]
    return result

def show_transform_multiply(scene, vec_a, vec_b, method="fft", rt=0.3):
    if not vec_a or not vec_b or any(v not in (0,1) for v in list(vec_a)+list(vec_b)): raise ValueError("教学例子使用非空GF(2)系数向量")
    n = 1
    while n<len(vec_a)+len(vec_b)-1: n*=2
    if n>16: raise ValueError("动画示例限变换长度<=16")
    panel = _gl3_context()
    ga = _gl3_row(scene,panel,vec_a,"A",1.5,F_COLOR)
    gb = _gl3_row(scene,panel,vec_b,"B",0.75,Q_COLOR)
    za = _gl3_row(scene,panel,[0]*n,"A补零",-0.1,F_COLOR,visible=False)
    zb = _gl3_row(scene,panel,[0]*n,"B补零",-0.95,Q_COLOR,visible=False)
    _gl3_transfer(scene,ga,za,[(i,i) for i in range(len(vec_a))],rt)
    _gl3_transfer(scene,gb,zb,[(i,i) for i in range(len(vec_b))],rt)
    for row,oldlen in ((za,len(vec_a)),(zb,len(vec_b))):
        for i in range(oldlen,n): _gl3_set_tile(row,i,0)
    _gl3_text(scene,panel,"补零到 "+str(n)+" 项；FFT使用复数，NTT使用模17",-2.0,size=23)
    a,b = za["values"][:],zb["values"][:]
    scene.wait(rt)
    clear_demo(scene,panel)
    fa = _gl3_transform_flow(scene,a,method,False,"A正变换",rt)
    fb = _gl3_transform_flow(scene,b,method,False,"B正变换",rt)
    panel = _gl3_context()
    ga = _gl3_numbers(scene,panel,fa,"A点值",1.5,F_COLOR)
    gb = _gl3_numbers(scene,panel,fb,"B点值",0.7,Q_COLOR)
    out = _gl3_numbers(scene,panel,[0]*n,"点值积",-1.2,X_COLOR,visible=False)
    fc = []
    for i in range(n):
        x = out["tiles"][i].get_center()[0]
        left,right = ga["tiles"][i].copy(),gb["tiles"][i].copy()
        scene.add(left,right)
        scene.play(left.animate.move_to(np.array([x-0.25,-0.15,0])),right.animate.move_to(np.array([x+0.25,-0.15,0])),run_time=rt)
        value = fa[i]*fb[i] if method=="fft" else fa[i]*fb[i]%17
        scene.play(Transform(left,_gl3_tile(value,np.array([x,-0.45,0]),out["sz"],X_COLOR)),FadeOut(right),run_time=rt)
        scene.play(left.animate.move_to(out["tiles"][i].get_center()),run_time=rt)
        _gl3_set_tile(out,i,value)
        scene.remove(left,right)
        fc.append(value)
    clear_demo(scene,panel)
    restored = _gl3_transform_flow(scene,fc,method,True,"乘积逆变换",rt)
    if method=="fft":
        error = max(max(abs(x.real-round(x.real)),abs(x.imag)) for x in restored)
        if error>1e-6: raise ArithmeticError("FFT未能正确恢复整数")
        integers = [int(round(x.real)) for x in restored]
    else: integers=[int(x) for x in restored]
    length = len(vec_a)+len(vec_b)-1
    ctx = _gl3_context()
    raw = _gl3_numbers(scene,ctx,integers[:length],"整系数",1.1,Y_COLOR)
    out = _gl3_row(scene,ctx,[0]*length,"GF(2)",-1.0,X_COLOR,visible=False,indices=True)
    _gl3_text(scene,ctx,"mod 2",0.05,size=25)
    for i,value in enumerate(integers[:length]):
        token = raw["tiles"][i].copy()
        scene.add(token)
        scene.play(token.animate.move_to(np.array([0,0.55,0])),run_time=rt)
        scene.play(Transform(token,_gl3_tile(value&1,np.array([0,-0.4,0]),out["sz"],X_COLOR)),run_time=rt)
        scene.play(token.animate.move_to(out["tiles"][i].get_center()),run_time=rt)
        _gl3_set_tile(out,i,value&1)
        scene.remove(token)
    ctx["result"],ctx["integer_result"] = out["values"][:],integers[:length]
    return ctx

class LightsOut(Scene):
    def construct(self):
        self.camera.background_color = BLACK
        rt = 0.4
        show_title(self, "点灯游戏：快速算法演示")
        show_subtitle(self, "沿用上一集的向量和矩阵表示。", "系数从左到右，按次数由低到高排列。")
        self.wait(2)

#——————————————————————
        show_title(self, "多项式系数变换")
        show_subtitle(self, "先演示拆分、合并、倒序、平方插零和低次截断。")
        for kind in ["split", "merge", "reverse", "square", "truncate"]:
            ctx = show_poly_transform(self, [1,1,0,1,1,0], kind=kind, split=3, precision=3)
            self.wait(1.5)
            clear_demo(self, ctx)

#——————————————————————
        show_title(self, "多项式乘法与卷积")
        show_subtitle(self, "先按乘数的系数移动部分积，再将部分积异或。")
        ctx = show_poly_product(self, [1,1,0,1], [1,0,1], mode="multiply", rt=rt)
        self.wait(2)
        clear_demo(self, ctx)
        show_subtitle(self, "同样的乘法，也可以逐个输出位置观察。", "把重叠系数相乘后异或，就是卷积。")
        ctx = show_poly_product(self, [1,1,0,1], [1,0,1], mode="convolution", rt=rt)
        self.wait(2)
        clear_demo(self, ctx)

#——————————————————————
        show_title(self, "分治：拆分与合并")
        show_subtitle(self, "先将规模8拆为两个规模4，再拆为规模2。", "计算结果按照相反顺序合并回来。")
        tree = {"label":"n=8", "children":[{"label":"n=4", "children":[{"label":"n=2"},{"label":"n=2"}]} for _ in range(2)]}
        ctx = show_divide_conquer(self, tree)
        self.wait(2)
        clear_demo(self, ctx)

#——————————————————————
        show_title(self, "Fibonacci 多项式倍增")
        show_subtitle(self, "以n=11为例，计算路径是0、1、2、5、11。", "这里f[0]=1，f[1]=t；c(t)=f(t+1)。")
        ctx = show_fibonacci_double(self, 11, rt=0.8)
        self.wait(2)
        clear_demo(self, ctx)

#——————————————————————
        show_title(self, "Karatsuba：两分三乘")
        show_subtitle(self, "将两个多项式各拆为两段。", "三个子乘积就能恢复原本需要四次乘法的结果。")
        ctx = show_karatsuba(self, [1,1,0,1], [1,0,1,1], depth=1)
        self.wait(2)
        clear_demo(self, ctx)

#——————————————————————
        show_title(self, "普通长除法")
        show_subtitle(self, "A=t^4+t+1，B=t^3+t+1。", "每次对齐最高次项并异或，同时记录商。")
        ctx = show_poly_division(self, [1,1,0,0,1], [1,1,0,1], mode="long")
        self.wait(2)
        clear_demo(self, ctx)
        show_title(self, "Newton：模t的幂求逆")
        show_subtitle(self, "以P=1+t+t^3为例。", "从精度1开始，每次平方误差，使正确精度翻倍。")
        ctx = show_newton_inverse(self, [1,1,0,1], 8, rt=0.7)
        self.wait(2)
        clear_demo(self, ctx)
        show_title(self, "多项式快速除法")
        show_subtitle(self, "回到同一个除法例子，演示倒序、求逆、乘法求商和恢复余数。")
        ctx = show_poly_division(self, [1,1,0,0,1], [1,1,0,1], mode="fast", rt=0.8)
        self.wait(2)
        clear_demo(self, ctx)

#——————————————————————
        show_title(self, "Half-GCD：合并 Euclid 变换")
        show_subtitle(self, "演示高次截取、递归变换及精确除法修正。", "随后继续迭代，求出最终GCD；画面中的矩阵来自实际计算。")
        ctx = show_half_gcd(self, _gl3_vec(int("11100101",2),8), _gl3_vec(int("01101101",2),8), depth=1)
        self.wait(2)
        clear_demo(self, ctx)

#——————————————————————
        show_title(self, "Laurent 核与有限边界")
        show_subtitle(self, "P(t)=1+t+t^2，将t替换为z^-1+z，生成Laurent核。", "先计算无限直线卷积，再将越过零边界的贡献反射回来。")
        ctx = show_kernel_operator(self, {}, [1,0,1,1,0], polynomial=[1,1,1])
        self.wait(2)
        clear_demo(self, ctx)
        show_title(self, "全1源：前缀异或")
        show_subtitle(self, "全1向量使每个卷积输出变成核的区间异或。", "前缀异或避免对每个位置重复扫描核。")
        ctx = show_kernel_operator(self, {-2:1,-1:1,1:1,2:1}, [1]*5, mode="ones")
        self.wait(2)
        clear_demo(self, ctx)

#——————————————————————
        show_title(self, "三角 Toeplitz 与反卷积")
        show_subtitle(self, "这里直接使用已确定的三角子系统。", "核A=1+t+t^2，输入Z已知，利用A的截断逆求X。")
        ctx = show_kernel_operator(self, [1,1,1], [1,0,0,0,0], mode="reverse")
        self.wait(2)
        clear_demo(self, ctx)

#——————————————————————
        show_title(self, "FFT：变换后逐点相乘")
        show_subtitle(self, "以两个三项多项式为例，补零到8个系数。", "演示正变换、蝶形、逐点乘法和逆变换。")
        ctx = show_transform_multiply(self, [1,1,1], [1,0,1], method="fft")
        self.wait(2)
        clear_demo(self, ctx)
        show_title(self, "NTT：模素数的精确变换")
        show_subtitle(self, "相同例子改为模17的数论变换，原根取3。", "恢复整数卷积后再模2，与普通多项式乘法对照。")
        ctx = show_transform_multiply(self, [1,1,1], [1,0,1], method="ntt")
        self.wait(2)
        clear_demo(self, ctx)
        show_title(self, "新增函数示例结束")
        self.wait(2)
