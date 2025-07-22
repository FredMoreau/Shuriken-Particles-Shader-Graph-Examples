using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using UnityEditor.UIElements;

namespace Unity.ShurikenTools.Editor
{
    public class MeshTool : EditorWindow
    {
        [MenuItem("Window/Shuriken Particles/Mesh Tool")]
        public static void ShowExample()
        {
            MeshTool wnd = GetWindow<MeshTool>();
            wnd.titleContent = new GUIContent("Shuriken Particles Mesh Tool");
        }

        Mesh mesh;

        public void CreateGUI()
        {
            VisualElement root = rootVisualElement;

            ObjectField meshField = new ObjectField("mesh")
            {
                objectType = typeof(Mesh),
            };
            meshField.RegisterValueChangedCallback(evt =>
            {
                mesh = (Mesh)evt.newValue;
            });

            root.Add(meshField);

            Button button = new Button()
            {
                text = "Proceed"
            };
            button.clicked += OnClick;

            root.Add(button);
        }

        void OnClick()
        {
            if (mesh == null)
                return;

            var path = EditorUtility.SaveFilePanelInProject("Make Particle Mesh", mesh.name, "asset", "Save new Mesh");
            if (string.IsNullOrEmpty(path))
                return;

            Mesh newMesh = new Mesh();
            newMesh.vertices = mesh.vertices;
            newMesh.colors = mesh.colors;
            newMesh.triangles = mesh.triangles;
            newMesh.uv = mesh.uv;
            newMesh.uv2 = mesh.uv;

            AssetDatabase.CreateAsset(newMesh, path);
        }
    }
}
