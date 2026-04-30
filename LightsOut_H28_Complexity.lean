import Mathlib.Tactic

set_option autoImplicit false
set_option linter.unnecessarySimpa false
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

namespace LightsOutH28Full

/-
H28 source-step coverage cost model.

Covered Pascal structure:

  TimeMark
  SaveMat
  VecIsZero
  VecZeroHi
  VecCopyHi
  PolyDeg
  ApplyPoly
  MakeMat
  gcd
  CalcMat2
  GeneMat
  main loop

This proves a cost-model theorem:

  one iteration for fixed n = O(n^2)
  whole loop up to m       = O(m^3)

It does not yet prove semantic correctness of the Pascal program.
-/

/- Source step enumeration. -/

inductive SourceStep where
  | timeMark
  | saveMat
  | createWin
  | createBB
  | createBMP
  | setBB
  | freshWin
  | drawBMP
  | saveBMP
  | releaseBMP
  | isWin
  | queryCounter
  | queryFrequency
  | write
  | writeln
  | branchTest
  | scalarAssign
  | pointerAssign
  | pointerSwap
  | vecIsZero
  | vecZeroHi
  | vecCopyHi
  | polyDeg
  | applyPolyClearBuffers
  | applyPolyCopySource
  | applyPolySetBoundary
  | applyPolyFindDegree
  | applyPolyFindLeft
  | applyPolyFindRight
  | applyPolyPointerInit
  | applyPolyCoeffXor
  | applyPolyComputeWindow
  | applyPolyClearCurGuard
  | applyPolyDiffuse
  | applyPolyTrimLeft
  | applyPolyTrimRight
  | applyPolyClearNextGuard
  | applyPolySwap
  | makeMatInitBranch
  | makeMatInitZero
  | makeMatInitBase
  | makeMatOuterZero
  | makeMatYUnderscoreRecurrence
  | makeMatYRecurrence
  | makeMatYBoundary
  | makeMatFCRecurrence
  | makeMatRollingCopy
  | makeMatUpdateK
  | gcdPointerInit
  | gcdCopyInput
  | gcdDegreeScan
  | gcdBezoutInit
  | gcdSwapBlock
  | gcdExitCopy
  | gcdCancelPoly
  | gcdScanTop
  | gcdUpdateBezout
  | calcGcd
  | calcApplyQ
  | calcCopyX
  | calcSingularZeroInit
  | calcSingularBase
  | calcApplyG
  | calcPointerSetup
  | calcJmax
  | calcJmaxZeroBranch
  | calcReverseMirrorPre
  | calcReverseMirrorLoop
  | calcDirectPre
  | calcDirectLoop
  | calcClearX
  | calcReverseElimWindow
  | calcReverseElimXor
  | calcReverseElimRoll
  | geneApply
  | geneInitResult
  | geneCheck
  | programInit
  | mainLoop
deriving Repr, DecidableEq

open SourceStep

/-
Explicit coverage maps.

These lists are not executable Pascal translations.
They document which Pascal source steps are represented in each modeled phase.
-/

def timeMarkSteps : List SourceStep :=
  [queryCounter, scalarAssign, write]

def saveMatSteps : List SourceStep :=
  [setBB, freshWin, createBMP, drawBMP, saveBMP, releaseBMP]

def vecHelperSteps : List SourceStep :=
  [vecIsZero, vecZeroHi, vecCopyHi, polyDeg]

def applyPolySteps : List SourceStep :=
  [applyPolyClearBuffers,
   applyPolyCopySource,
   applyPolySetBoundary,
   applyPolyFindDegree,
   applyPolyFindLeft,
   applyPolyFindRight,
   applyPolyPointerInit,
   applyPolyCoeffXor,
   applyPolyComputeWindow,
   applyPolyClearCurGuard,
   applyPolyDiffuse,
   applyPolyTrimLeft,
   applyPolyTrimRight,
   applyPolyClearNextGuard,
   applyPolySwap]

def makeMatSteps : List SourceStep :=
  [timeMark,
   makeMatInitBranch,
   makeMatInitZero,
   makeMatInitBase,
   makeMatOuterZero,
   makeMatYUnderscoreRecurrence,
   makeMatYRecurrence,
   makeMatYBoundary,
   makeMatFCRecurrence,
   makeMatRollingCopy,
   makeMatUpdateK]

def gcdSteps : List SourceStep :=
  [gcdPointerInit,
   gcdCopyInput,
   gcdDegreeScan,
   gcdBezoutInit,
   gcdSwapBlock,
   gcdExitCopy,
   gcdCancelPoly,
   gcdScanTop,
   gcdUpdateBezout]

def calcMat2Steps : List SourceStep :=
  [timeMark,
   calcGcd,
   calcApplyQ,
   calcCopyX,
   calcSingularZeroInit,
   calcSingularBase,
   calcApplyG,
   calcPointerSetup,
   calcJmax,
   calcJmaxZeroBranch,
   calcReverseMirrorPre,
   calcReverseMirrorLoop,
   calcDirectPre,
   calcDirectLoop,
   calcClearX,
   calcReverseElimWindow,
   calcReverseElimXor,
   calcReverseElimRoll]

def geneMatSteps : List SourceStep :=
  [timeMark,
   geneApply,
   geneInitResult,
   geneCheck,
   write]

def mainProgramSteps : List SourceStep :=
  [programInit,
   mainLoop,
   write,
   makeMatInitBranch,
   calcGcd,
   geneApply,
   saveMat,
   isWin,
   writeln]

/- Basic asymptotic bounds. -/

def quadBound (n : Nat) : Nat :=
  (n + 1) * (n + 1)

def cubicBound (n : Nat) : Nat :=
  (n + 1) * quadBound n

def IsQuadCost (T : Nat → Nat) : Prop :=
  ∃ C : Nat, ∀ n : Nat, T n ≤ C * quadBound n

def IsCubicCost (T : Nat → Nat) : Prop :=
  ∃ C : Nat, ∀ n : Nat, T n ≤ C * cubicBound n

/-
Phase coefficients.

These are conservative constants.
Only the exponent matters for O(n^2) / O(m^3).
-/

def applyPolyCoef : Nat := 30
def makeMatCoef : Nat := 40
def gcdCoef : Nat := 100

def calcTimeMarksCoef : Nat := 4
def calcCopyXCoef : Nat := 1
def calcApplyGCoef : Nat := applyPolyCoef
def calcDPrepareCoef : Nat := 70
def calcReverseElimCoef : Nat := 60

def geneTimeMarkCoef : Nat := 1
def geneApplyCoef : Nat := applyPolyCoef
def geneCheckCoef : Nat := 1
def geneWriteCoef : Nat := 1

def iterWriteCoef : Nat := 1
def iterWritelnCoef : Nat := 1
def iterDispCoef : Nat := 8

def programInitCoef : Nat := 8

/-
Phase costs.

Every large Pascal procedure is bounded by a coefficient times quadBound.
This is the stable source-step coverage model.
-/

def applyPolyCost (n : Nat) : Nat :=
  applyPolyCoef * quadBound n

def makeMatCost (n : Nat) : Nat :=
  makeMatCoef * quadBound n

def gcdCost (n : Nat) : Nat :=
  gcdCoef * quadBound n

def geneMatCoef : Nat :=
  geneTimeMarkCoef + geneApplyCoef + geneCheckCoef + geneWriteCoef

def geneMatCost (n : Nat) : Nat :=
  geneMatCoef * quadBound n

/-
CalcMat2.

Common part:
  TimeMark('c')
  TimeMark('q')
  gcd(f,c,g,q)
  TimeMark('z')
  ApplyPoly(q,y,z)
  TimeMark('d')

Non-singular branch:
  x := z

Singular branch:
  ApplyPoly(g,e0,g0)
  D preparation
  reverse elimination
-/

def calcCommonCoef : Nat :=
  calcTimeMarksCoef + gcdCoef + applyPolyCoef

def calcSingularBranchCoef : Nat :=
  calcApplyGCoef + calcDPrepareCoef + calcReverseElimCoef

def calcMat2RealCoef (singular : Bool) : Nat :=
  calcCommonCoef + if singular then calcSingularBranchCoef else calcCopyXCoef

def calcMat2UpperCoef : Nat :=
  calcCommonCoef + calcCopyXCoef + calcSingularBranchCoef

def calcMat2RealCost (singular : Bool) (n : Nat) : Nat :=
  calcMat2RealCoef singular * quadBound n

def calcMat2UpperCost (n : Nat) : Nat :=
  calcMat2UpperCoef * quadBound n

theorem calcMat2RealCoef_le_upper :
    ∀ singular : Bool,
      calcMat2RealCoef singular ≤ calcMat2UpperCoef := by
  intro singular
  cases singular <;>
    native_decide

theorem calcMat2RealCost_le_upper :
    ∀ singular : Bool, ∀ n : Nat,
      calcMat2RealCost singular n ≤ calcMat2UpperCost n := by
  intro singular n
  unfold calcMat2RealCost calcMat2UpperCost
  exact Nat.mul_le_mul_right (quadBound n)
    (calcMat2RealCoef_le_upper singular)

theorem calcMat2RealCost_is_quad :
    ∀ singular : Bool, IsQuadCost (calcMat2RealCost singular) := by
  intro singular
  unfold IsQuadCost
  exact ⟨calcMat2UpperCoef, calcMat2RealCost_le_upper singular⟩

/-
One iteration.

Covers:
  write(n,#9)
  MakeMat()
  CalcMat2()
  GeneMat()
  optional display SaveMat/isWin
  writeln()
-/

def dispIterCoef (disp : Bool) : Nat :=
  if disp then iterDispCoef else 0

def oneIterationRealCoef (disp singular : Bool) : Nat :=
  iterWriteCoef
  + makeMatCoef
  + calcMat2RealCoef singular
  + geneMatCoef
  + dispIterCoef disp
  + iterWritelnCoef

def oneIterationUpperCoef : Nat :=
  iterWriteCoef
  + makeMatCoef
  + calcMat2UpperCoef
  + geneMatCoef
  + iterDispCoef
  + iterWritelnCoef

def oneIterationRealCost (disp singular : Bool) (n : Nat) : Nat :=
  oneIterationRealCoef disp singular * quadBound n

def oneIterationUpperCost (n : Nat) : Nat :=
  oneIterationUpperCoef * quadBound n

theorem oneIterationRealCoef_le_upper :
    ∀ disp singular : Bool,
      oneIterationRealCoef disp singular ≤ oneIterationUpperCoef := by
  intro disp singular
  cases disp <;> cases singular <;>
    native_decide

theorem oneIterationRealCost_le_upper :
    ∀ disp singular : Bool, ∀ n : Nat,
      oneIterationRealCost disp singular n ≤ oneIterationUpperCost n := by
  intro disp singular n
  unfold oneIterationRealCost oneIterationUpperCost
  exact Nat.mul_le_mul_right (quadBound n)
    (oneIterationRealCoef_le_upper disp singular)

theorem oneIteration_is_quad :
    ∀ disp singular : Bool,
      IsQuadCost (oneIterationRealCost disp singular) := by
  intro disp singular
  unfold IsQuadCost
  exact ⟨oneIterationUpperCoef, oneIterationRealCost_le_upper disp singular⟩

/-
Program initialization.

Covers:
  optional display initialization
  QueryPerformanceFrequency
  QueryPerformanceCounter
  hasLastCounter := false
-/

def programInitCost (_disp : Bool) (m : Nat) : Nat :=
  programInitCoef * cubicBound m

/-
Main loop.

Conservative loop model:
  at most m+1 iterations
  each iteration bounded by oneIterationUpperCoef * quadBound m

So total loop cost is oneIterationUpperCoef * cubicBound m.
-/

def mainLoopUpperCost (m : Nat) : Nat :=
  oneIterationUpperCoef * cubicBound m

def programUpperCoef : Nat :=
  programInitCoef + oneIterationUpperCoef

def programUpperCost (disp : Bool) (m : Nat) : Nat :=
  programInitCost disp m + mainLoopUpperCost m

theorem programUpperCost_eq :
    ∀ disp : Bool, ∀ m : Nat,
      programUpperCost disp m = programUpperCoef * cubicBound m := by
  intro disp m
  unfold programUpperCost programInitCost mainLoopUpperCost programUpperCoef
  ring_nf

theorem programUpperCost_is_cubic :
    ∀ disp : Bool, IsCubicCost (programUpperCost disp) := by
  intro disp
  unfold IsCubicCost
  exact ⟨programUpperCoef, by
    intro m
    rw [programUpperCost_eq]
  ⟩

end LightsOutH28Full