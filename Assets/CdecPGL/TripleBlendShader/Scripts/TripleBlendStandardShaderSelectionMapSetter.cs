using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace CdecPGL.TripleBlendShader {
	/// <summary>
	/// A class to set SelectionMap texture to renderers which or whose children have material using TripleBlendStandardShader.
	/// </summary>
	public sealed class TripleBlendStandardShaderSelectionMapSetter : MonoBehaviour {
		/// <summary>
		/// Set SelectionMap texture to all objects which has TripleBlendStandardShaderSelectionMapSetter component in the scene.
		/// </summary>
		public static void SetSelectionMapTextureAndAreaToAll(Texture texture, Rect area) {
			var targets = FindObjectsOfType<TripleBlendStandardShaderSelectionMapSetter>();
			foreach (var target in targets) {
				target.SetSelectionMapTexture(texture);
				target.SetSelectionArea(area);
			}
		}

		/// <summary>
		/// Set SelectionMap texture.
		/// </summary>
		/// <param name="texture"></param>
		public void SetSelectionMapTexture(Texture texture) {
			foreach (var myMaterial in _mySelectionMapRendererMaterialList) {
				myMaterial.SetTexture(_selectionMapPropertyId, texture);
			}
		}

		/// <summary>
		/// Set SelectionArea.
		/// </summary>
		/// <param name="area"></param>
		public void SetSelectionArea(Rect area) {
			var areaVector = new Vector4(area.xMin, area.yMin, area.xMax, area.yMax);
			foreach (var myMaterial in _mySelectionMapRendererMaterialList) {
				myMaterial.SetVector(_selectionAreaPropertyId, areaVector);
			}
		}

		private List<Material> _mySelectionMapRendererMaterialList = new List<Material>();

#if UNITY_EDITOR
		private struct PropertyBackup {
			public Texture selectionMap;
			public Vector4 selectionArea;
		}

		private readonly Dictionary<Material, PropertyBackup> _materialPropertyBackup =
			new Dictionary<Material, PropertyBackup>();
#endif

		private static readonly int _selectionMapPropertyId = Shader.PropertyToID("_SelectionMap");
		private static readonly int _selectionAreaPropertyId = Shader.PropertyToID("_SelectionArea");

		private void Awake() {
			// Add materials which have _SelectionMap property from Renderer Component.
			// Target components is searched from this game object and all child game objects.
			_mySelectionMapRendererMaterialList = GetComponentsInChildren<Renderer>().Append(GetComponent<Renderer>())
				.Where(r => r).Select(r => r.materials).SelectMany(m => m)
				.Where(m => m.HasProperty(_selectionMapPropertyId)).ToList();

			// Add materials which have _SelectionMap property from Terrain Component.
			// Target components is searched from this game object and all child game objects.			
			_mySelectionMapRendererMaterialList.AddRange(GetComponentsInChildren<Terrain>()
				.Append(GetComponent<Terrain>())
				.Where(t => t && t.materialTemplate.HasProperty(_selectionMapPropertyId))
				.Select(t => t.materialTemplate).ToList());

#if UNITY_EDITOR
			// Revert material settings manually because material settings are not reverted in Unity2018.3.7f1 when play in editor.
			foreach (var myMaterial in _mySelectionMapRendererMaterialList) {
				if (!_materialPropertyBackup.ContainsKey(myMaterial)) {
					_materialPropertyBackup.Add(myMaterial,
						new PropertyBackup {
							selectionMap = myMaterial.GetTexture(_selectionMapPropertyId),
							selectionArea = myMaterial.GetVector(_selectionAreaPropertyId)
						});
				}
			}
#endif
		}

#if UNITY_EDITOR
		private void OnDestroy() {
			foreach (var myMaterial in _mySelectionMapRendererMaterialList) {
				if (!_materialPropertyBackup.ContainsKey(myMaterial)) {
					continue;
				}

				myMaterial.SetTexture(_selectionMapPropertyId, _materialPropertyBackup[myMaterial].selectionMap);
				myMaterial.SetVector(_selectionAreaPropertyId, _materialPropertyBackup[myMaterial].selectionArea);
			}
		}
#endif
	}
}
